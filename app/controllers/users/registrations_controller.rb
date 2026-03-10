class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def create
    super do |user|
      if user.persisted? && params[:user][:profile_photo].present?
        result = Cloudinary::Uploader.upload(params[:user][:profile_photo].tempfile.path)
        user.update_column(:profile_photo_url, result["secure_url"])
      end
    end
  end

  private

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :city, :profile_photo])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :city, :profile_photo])
  end
end
