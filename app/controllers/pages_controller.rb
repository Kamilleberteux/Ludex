class PagesController < ApplicationController

  def home
    if user_signed_in?
      @collections = current_user.collections.includes(:games)
      @suggestion_games = Game.all.sample(4)
    end
  end
end
