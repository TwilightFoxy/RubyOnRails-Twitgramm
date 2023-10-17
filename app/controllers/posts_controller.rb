class PostsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_post, only: [:destroy]

  def index
    @post = current_user.posts.build
    @posts = Post.order(created_at: :desc)
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: 'Пост успешно создан.'
    else
      @posts = Post.order(created_at: :desc)
      render :index
    end
  end

  def destroy
    if @post.user == current_user
      @post.destroy
      redirect_to root_path, notice: 'Пост успешно удален.'
    else
      redirect_to root_path, alert: 'Ошибка удаления.'
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:description)
  end
end
