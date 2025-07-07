class ProfilesController < ApplicationController
  before_action :require_login

  def show
    @profile = current_user.profile || current_user.create_profile
    @posts = current_user.posts.recent.includes(:category, :likes)
  end

  def edit
    @profile = current_user.profile || current_user.create_profile
  end

  def update
    @profile = current_user.profile || current_user.create_profile
    
    if @profile.update(profile_params)
      flash[:notice] = "Profile updated successfully!"
      redirect_to profile_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:bio, :avatar)
  end
end
