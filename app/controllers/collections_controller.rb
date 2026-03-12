class CollectionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @collections = Collection.all
  end

  def show
  @collections = current_user.collections
  @current_collection = Collection.find(params[:id])
  @games = @current_collection.games
  end

  def add_game
    @collection = current_user.collections.find(params[:id])
    @game = Game.find(params[:game_id])

    if @collection.games << @game
      redirect_back fallback_location: game_path(@game)
    else
      redirect_to game_path(@game), alert: "Impossible d'ajouter le jeu."
    end
  end

  private

  def collection_params
    params.require(:collection).permit(:name, :description)
  end
end
