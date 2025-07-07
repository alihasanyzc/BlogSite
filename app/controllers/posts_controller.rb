class PostsController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like, :unlike]
  before_action :require_post_owner, only: [:edit, :update, :destroy]

  def index
    @posts = Post.recent.includes(:user, :category, :likes)
    @categories = Category.all
    
    if params[:category_id].present?
      @posts = @posts.where(category_id: params[:category_id])
      @selected_category = Category.find(params[:category_id])
    end
  end

  def show
    @comment = Comment.new
    @comments = @post.comments.recent.includes(:user)
  end

  def new
    @post = current_user.posts.build
    @categories = Category.all
  end

  def create
    @post = current_user.posts.build(post_params)
    
    if @post.save
      flash[:notice] = "Post created successfully!"
      redirect_to @post
    else
      @categories = Category.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "Post updated successfully!"
      redirect_to @post
    else
      @categories = Category.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "Post deleted successfully!"
    redirect_to root_path
  end

  def like
    @like = @post.likes.find_by(user: current_user)
    
    if @like
      @like.update(liked: true)
    else
      @post.likes.create(user: current_user, liked: true)
    end
    
    redirect_to @post
  end

  def unlike
    @like = @post.likes.find_by(user: current_user)
    @like&.update(liked: false)
    
    redirect_to @post
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def require_post_owner
    redirect_to root_path unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(:title, :body, :category_id)
  end
end
