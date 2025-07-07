class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_post
  before_action :set_comment, only: [:destroy]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    
    if @comment.save
      flash[:notice] = "Comment added successfully!"
    else
      flash[:alert] = "Error adding comment."
    end
    
    redirect_to @post
  end

  def destroy
    if @comment.user == current_user
      @comment.destroy
      flash[:notice] = "Comment deleted successfully!"
    else
      flash[:alert] = "You can only delete your own comments."
    end
    
    redirect_to @post
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
