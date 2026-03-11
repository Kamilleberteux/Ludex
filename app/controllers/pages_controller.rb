class PagesController < ApplicationController

  def home
    if user_signed_in?
      @collections = current_user.collections.includes(:games)
    end
  end
end
