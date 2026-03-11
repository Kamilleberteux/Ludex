class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
  end

  def edit
  end

  def update
    if params[:user][:profile_photo].present?
      result = Cloudinary::Uploader.upload(params[:user][:profile_photo].tempfile.path)
      @user.profile_photo_url = result["secure_url"]
    end

    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :city, :profile_photo_url)
  end
end
