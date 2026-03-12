class GamesController < ApplicationController
  def recommendation_form
  end

  def recommendation
    @games = Game.all

    # Nombre de joueurs
    if params[:nb_players].present?
      nb = params[:nb_players].to_i
      @games = @games.where("nb_players_min <= ? AND nb_players_max >= ?", nb, nb)
    end

    # Temps de jeu
    case params[:play_time]
    when "30"  then @games = @games.where("play_time_minutes <= 30")
    when "60"  then @games = @games.where("play_time_minutes BETWEEN 31 AND 75")
    when "120" then @games = @games.where("play_time_minutes BETWEEN 76 AND 150")
    when "180" then @games = @games.where("play_time_minutes > 150")
    end

    # Public / niveau
    case params[:audience]
    when "children" then @games = @games.where(level: "Enfant")
    when "all" then @games = @games.where(level: "Familial")
    when "casual" then @games = @games.where(level: "Initié")
    when "expert" then @games = @games.where(level: "Expert")
    end

    # Thème
    nature = []
    urbain = []
    fantastique = []

    @games = @games.where(theme: params[:theme]) if params[:theme].present? && params[:theme] != "any"

    # Type d'interaction
    case params[:interaction]
    when "competitive" then @games = @games.where(is_cooperative: false)
    when "cooperative" then @games = @games.where(is_cooperative: true)
    end

    # Budget
    if params[:budget].present? && params[:budget] != "any"
      @games = @games.where("price <= ?", params[:budget].to_f)
    end

    @recommended_games = @games.limit(3).to_a

    # Fallback si moins de 3 résultats
    if @recommended_games.size < 3
      fallback = Game.where.not(id: @recommended_games.map(&:id))
                     .limit(3 - @recommended_games.size)
      @recommended_games += fallback.to_a
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
end
