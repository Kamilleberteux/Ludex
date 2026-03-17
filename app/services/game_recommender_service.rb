class GameRecommenderService
  def initialize(params)
    @params = params
  end

  def call
    @games = Game.all

    # Nombre de joueurs
    case @params[:nb_players]
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

    case @params[:play_time]
    when "30"  then @games = @games.where(play_time_minutes: around_30)
    when "60"  then @games = @games.where(play_time_minutes: around_1h)
    when "120" then @games = @games.where(play_time_minutes: around_2h)
    when "180" then @games = @games.where(play_time_minutes: more_than_2h)
    end

    # Public / niveau
    case @params[:audience]
    when "children" then @games = @games.where(level: "Enfant")
    when "all" then @games = @games.where(level: "Familial")
    when "casual" then @games = @games.where(level: "Initié")
    when "expert" then @games = @games.where(level: "Expert")
    end

    # Type d'interaction
    case @params[:interaction]
    when "competitive" then @games = @games.where(is_cooperative: false)
    when "cooperative" then @games = @games.where(is_cooperative: true)
    end

    # Budget
    case @params[:budget]
    when "20"  then @games = @games.where("price BETWEEN 10 AND 20")
    when "50"  then @games = @games.where("price BETWEEN 30 AND 50")
    when "100" then @games = @games.where("price BETWEEN 60 AND 100")
    when "any" then @games = @games.where("price BETWEEN 100 AND 300")
    end

    @recommended_games = @games.order("RANDOM()").limit(4).to_a

    # Fallback progressif : relâche les critères un par un si moins de 4 résultats
    %i[
      apply_players_playtime_audience_interaction
      apply_players_audience_interaction
      apply_players_audience
      apply_players
    ].each do |scope|
      break if @recommended_games.size >= 4

      excluded_ids = @recommended_games.map(&:id)
      fallback = send(scope, @params).where.not(id: excluded_ids).order("RANDOM()").limit(4 - @recommended_games.size)
      @recommended_games += fallback.to_a
    end

    if @recommended_games.size < 4
      @recommended_games += Game.where.not(id: @recommended_games.map(&:id))
                                .order("RANDOM()").limit(4 - @recommended_games.size).to_a
    end

    @recommended_games
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
