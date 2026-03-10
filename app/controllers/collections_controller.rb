class CollectionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @collections = Collection.all
  end

  def show
  @collections = current_user.collections # Pour la barre du haut
  @current_collection = Collection.find(params[:id]) # La sélectionnée
  # @games = @current_collection.games # Les jeux à afficher en dessous
  end

  # def add_game
  #   @collection = current_user.collections.find(params[:id])
  #   @game = Game.find(params[:game_id])

  #   if @collection.games << @game
  #     # On redirige l'utilisateur là où il était avec un message flash
  #     redirect_to game_path(@game), notice: "Le jeu a bien été ajouté à votre collection #{@collection.name} !"
  #   else
  #     redirect_to game_path(@game), alert: "Impossible d'ajouter le jeu."
  #   end
  end


  # def new
  # @collection = current_user.collections.build
  # end

# def create
#   @collection = current_user.collections.build(collection_params)

#   if @collection.save
#     # On redirige l'utilisateur vers la liste des collections ou la nouvelle collection
#     redirect_to collections_path, notice: "La collection '#{@collection.name}' a été créée."
#   else
#     # Si erreur (ex: nom vide), on réaffiche le formulaire
#     render :new, status: :unprocessable_entity
#   end
# end


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
