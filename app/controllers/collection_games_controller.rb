class CollectionGamesController < ApplicationController
  def destroy
    @game_collection = CollectionGame.find(params[:id])
    @game_collection.destroy
    redirect_to collection_path(@game_collection.collection_id), status: :see_other
  end
end
