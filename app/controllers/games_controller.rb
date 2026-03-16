class GamesController < ApplicationController
  def recommendation_form
    if params[:query].present?
      @games = Game.where("name ILIKE ?", "%#{params[:query]}%")
    end
  end

  def similar_recommendation
    @game = Game.find(params[:game_id])
    @similar_games = Game.nearest_neighbors(:embedding, @game.embedding, distance: "euclidean").first(5)
    @similar_games.shift
  end

  def recommendation
    @games = Game.all

    # Nombre de joueurs
    case params[:nb_players]
    when "2" then @games = @games.where("nb_players_min <= 2 AND nb_players_max >= 2")
    when "4" then @games = @games.where("nb_players_min IN (2, 3) AND nb_players_max >= 4")
    when "6" then @games = @games.where("nb_players_min <= 5 AND nb_players_max >= 5")
    when "7" then @games = @games.where("nb_players_max >= 7")
    end

    # Temps de jeu
    around_30 = ["15 min", "30 min", "45 min"]
    around_1h = ["1h", "1h30"]
    around_2h = ["2h", "3h"]
    more_than_2h = ["6h", "5h", "4h"]

    case params[:play_time]
    when "30"  then @games = @games.where(play_time_minutes: around_30)
    when "60"  then @games = @games.where(play_time_minutes: around_1h)
    when "120" then @games = @games.where(play_time_minutes: around_2h)
    when "180" then @games = @games.where(play_time_minutes: more_than_2h)
    end

    # Public / niveau
    case params[:audience]
    when "children" then @games = @games.where(level: "Enfant")
    when "all" then @games = @games.where(level: "Familial")
    when "casual" then @games = @games.where(level: "Initié")
    when "expert" then @games = @games.where(level: "Expert")
    end

    # Type d'interaction
    case params[:interaction]
    when "competitive" then @games = @games.where(is_cooperative: false)
    when "cooperative" then @games = @games.where(is_cooperative: true)
    end

    # Budget
    case params[:budget]
    when "20"  then @games = @games.where("price BETWEEN 10 AND 20")
    when "50"  then @games = @games.where("price BETWEEN 30 AND 50")
    when "100" then @games = @games.where("price BETWEEN 60 AND 100")
    when "any" then @games = @games.where("price BETWEEN 100 AND 300")
    end

    @recommended_games = @games.order("RANDOM()").limit(4).to_a

    # Fallback progressif : relâche les critères un par un si moins de 3 résultats
    %i[
      apply_players_playtime_audience_interaction
      apply_players_audience_interaction
      apply_players_audience
      apply_players
    ].each do |scope|
      break if @recommended_games.size >= 4

      excluded_ids = @recommended_games.map(&:id)
      fallback = send(scope, params).where.not(id: excluded_ids).order("RANDOM()").limit(4 - @recommended_games.size)
      @recommended_games += fallback.to_a
    end

    return unless @recommended_games.size < 4

    @recommended_games += Game.where.not(id: @recommended_games.map(&:id))
                              .order("RANDOM()").limit(3 - @recommended_games.size).to_a

    if params[:query].present?
      @games = @games.where("name ILIKE ? OR description ILIKE ?", "%#{params[:query]}%",
      "%#{params[:query]}%")
    end

  end

  def show
    @game = Game.find(params[:id])
    @similar_games = Game.nearest_neighbors(:embedding, @game.embedding, distance: "euclidean").first(5)
    @similar_games.shift
  end

  def index
    @games = Game.all
    if params[:query].present?
      @games = @games.where("name ILIKE ? OR description ILIKE ?", "%#{params[:query]}%",
      "%#{params[:query]}%")
    end
    @games = @games.where(theme: params[:theme]) if params[:theme].present?
    if params[:nb_players].present?
      nb_players = params[:nb_players].to_i
      @games = @games.where("nb_players_min <= ? AND nb_players_max >= ?", nb_players, nb_players)
    end
    @games = @games.where(age_player: params[:age_player]) if params[:age_player].present?
    @games = @games.where("price <= ?", params[:max_price].to_f) if params[:max_price].present?
    @games = @games.where(level: params[:level]) if params[:level].present?
    @games = @games.where(is_cooperative: params[:cooperative] == "true") if params[:cooperative].present?
    @games = @games.where(play_time_minutes: params[:play_time_minutes]) if params[:play_time_minutes].present?

    @games = case params[:sort]
             when "price_asc"     then @games.order(price: :asc)
             when "price_desc"    then @games.order(price: :desc)
             when "release_date"  then @games.order(release_date: :desc)
             when "name"          then @games.order(name: :asc)
             else @games
             end

    @themes             = Game.distinct.order(:theme).pluck(:theme).compact
    @age_options        = Game.distinct.order(:age_player).pluck(:age_player).compact
    @level_options      = Game.distinct.order(:level).pluck(:level).compact
    @play_time_options  = Game.distinct.order(:play_time_minutes).pluck(:play_time_minutes).compact
    filter_keys = %i[theme nb_players age_player max_price sort level cooperative play_time_minutes]
    @active_filters = filter_keys.count { |k| params[k].present? }

    @pagy, @games = pagy(
      @games,
      items: 6
    )

    if params[:page].present?
      if @games.any?
        render "scrollable_list" and return
      else
        render turbo_stream: turbo_stream.remove("next-page"), status: :no_content
      end
    end
  end

  private

  def apply_players(prms)
    games = Game.all
    case prms[:nb_players]
    when "2" then games.where("nb_players_min <= 2 AND nb_players_max >= 2")
    when "4" then games.where("nb_players_min IN (2, 3) AND nb_players_max >= 4")
    when "6" then games.where("nb_players_min <= 5 AND nb_players_max >= 5")
    when "7" then games.where("nb_players_max >= 7")
    else games
    end
  end

  def apply_players_audience(prms)
    games = apply_players(prms)
    case prms[:audience]
    when "children" then games.where(level: "Enfant")
    when "all"      then games.where(level: "Familial")
    when "casual"   then games.where(level: "Initié")
    when "expert"   then games.where(level: "Expert")
    else games
    end
  end

  def apply_players_audience_interaction(prms)
    games = apply_players_audience(prms)
    case prms[:interaction]
    when "competitive" then games.where(is_cooperative: false)
    when "cooperative" then games.where(is_cooperative: true)
    else games
    end
  end

  def apply_players_playtime_audience_interaction(prms)
    games        = apply_players_audience_interaction(prms)
    short_times  = ["15 min", "30 min", "45 min"]
    medium_times = ["1h", "1h30"]
    long_times   = ["2h", "3h"]
    very_long_times = ["6h", "5h", "4h"]
    case prms[:play_time]
    when "30"  then games.where(play_time_minutes: short_times)
    when "60"  then games.where(play_time_minutes: medium_times)
    when "120" then games.where(play_time_minutes: long_times)
    when "180" then games.where(play_time_minutes: very_long_times)
    else games
    end
  end
end
