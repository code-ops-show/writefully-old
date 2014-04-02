class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = get_post
  end

  def edit
    @post = get_post
  end

  def update
    @post = get_post
    if @post.update_attributes(post_params)
      set_flash :success, object: @post
      redirect_to posts_path
    else
      set_flash :error, object: @post
      render :edit
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      set_flash :success, object: @post
      redirect_to posts_path
    else
      set_flash :error, object: @post
      render :new
    end
  end

private

  def get_post
    Post.where(id: params[:id]).first
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
