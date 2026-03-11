class CollectionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @collections = Collection.all
  end

  def show
  @collections = current_user.collections # Pour la barre du haut
  @current_collection = Collection.find(params[:id]) # La sélectionnée
  @games = @current_collection.games # Les jeux à afficher en dessous
  end

  def add_game
    @collection = current_user.collections.find(params[:id])
    @game = Game.find(params[:game_id])

    if @collection.games << @game
      # On redirige l'utilisateur là où il était avec un message flash
      redirect_back fallback_location: game_path(@game), notice: "Jeu ajouté à la collection."
    else
      redirect_to game_path(@game), alert: "Impossible d'ajouter le jeu."
    end
  end



  private

  def collection_params
    params.require(:collection).permit(:name, :description)
  end
end
