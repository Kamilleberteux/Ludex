class CollectionsController < ApplicationController
  before action :authenticate_user!

  def index
    @collections = current_user.collections
  end

  def add_game
    @collection = current_user.collections.find(params[:id])
    @game = Game.find(params[:game_id])

    if @collection.games << @game
      # On redirige l'utilisateur là où il était avec un message flash
      redirect_to game_path(@game), notice: "Le jeu a bien été ajouté à votre collection #{@collection.name} !"
    else
      redirect_to game_path(@game), alert: "Impossible d'ajouter le jeu."
    end
  end


  # def create #pour crée la collection perso en option
  #   @collection = current_user.collections.build(collection_params)
  #   if @collection.save
  #     redirect_to collections_path, notice: 'Collection created successfully.'
  #   else
  #     render :new
  #   end
  # end

  private

  def collection_params
    params.require(:collection).permit(:name, :description)
  end
end
