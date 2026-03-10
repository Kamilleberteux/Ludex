class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])
  end

  def index
    @games = Game.all
    @games = @games.where("name ILIKE ? OR description ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%") if params[:query].present?
    @games = @games.where(theme: params[:theme]) if params[:theme].present?
    @games = @games.where(nb_players: params[:nb_players]) if params[:nb_players].present?
    @games = @games.where(age_player: params[:age_player]) if params[:age_player].present?
    @games = @games.where("price <= ?", params[:max_price].to_f) if params[:max_price].present?

    @games = case params[:sort]
             when "price_asc"     then @games.order(price: :asc)
             when "price_desc"    then @games.order(price: :desc)
             when "release_date"  then @games.order(release_date: :desc)
             when "name"          then @games.order(name: :asc)
             else @games
             end

    @themes         = Game.distinct.order(:theme).pluck(:theme).compact
    @player_options = Game.distinct.order(:nb_players).pluck(:nb_players).compact
    @age_options    = Game.distinct.order(:age_player).pluck(:age_player).compact
    @active_filters = %i[theme nb_players age_player max_price sort].count { |k| params[k].present? }
  end
end
