class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])
  end

  

  private
  def game_params
    params.require(:game).permit(:name, :description, :image_url_1)
  end
end
