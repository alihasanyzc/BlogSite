class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create, :show]
  before_action :set_user, only: [:show]

  def new
    redirect_to root_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      # Create profile for the user
      @user.create_profile
      
      session[:user_id] = @user.id
      flash[:notice] = "Welcome to our blog, #{@user.username}!"
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @posts = @user.posts.recent.includes(:category, :likes)
  end

  private

  def set_user
    @user = User.find_by(username: params[:username])
    redirect_to root_path unless @user
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
