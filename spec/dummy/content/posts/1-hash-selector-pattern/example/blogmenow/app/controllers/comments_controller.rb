class CommentsController < ApplicationController
  respond_to :js, :html

  def create
    @post = Post.where(id: params[:post_id]).first
    @comment = @post.comments.build(comment_params)

    { 
      true  => -> { respond_with @post, @comment },
      false => -> { xms_error @comment } 
    }[@comment.save].call

    # if @comment.save
    #   respond_with @post, @comment
    # else
    #   xms_error @comment
    # end
  end

private 
  def comment_params
    params.require(:comment).permit(:body)
  end
end