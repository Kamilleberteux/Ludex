class CollectionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @collections = Collection.all
  end

  def show
  @user = Collection.find(params[:id]).user
  @collections = @user.collections
  @current_collection = Collection.find(params[:id])
  @games = @current_collection.games

  # collection_path(friendship.friend.collection.first)
  # @user = User.find(params[:id])
  # if @user == current_user
  #   @collections = current_user.collections
  #   @current_collection = Collection.find(params[:id])
  #   @games = @current_collection.games
  # else
  #   @collections = @user.collections
  #   @current_collection = Collection.find(params[:id])
  #   @games = @current_collection.games
  # end

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
