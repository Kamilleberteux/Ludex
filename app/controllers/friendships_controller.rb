class FriendshipsController < ApplicationController

  def index
    @friendships = current_user.friendships
    if params[:query].present?
      @users = User.where("username ILIKE ?", "%#{params[:query]}%")
    end
  end

  def create
    @friendship = Friendship.new(friend_id: params[:user_id])
    @friendship.user = current_user
    @friendship.save
    redirect_to friendships_path
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy
    redirect_to friendships_path, status: :see_other
  end

  def collection
    @friend = Friendship.find(params[:id]).friend
    @collections = @friend.collections
    @current_collection = Collection.find(params[:collection_id])
    @games = @current_collection.games
  end
end
