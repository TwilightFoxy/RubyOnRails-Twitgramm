class PostsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_post, only: [:destroy]

  def index
    @post = current_user.posts.build
    @feed_items = current_user.feed.order(created_at: :desc)
  end

  # def feed
  #   following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
  #   Post.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: current_user.id)
  # end

  # def show
  #   @post = Post.find(params[:id])
  # end
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: 'Пост успешно создан.'
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

  # def edit
  #   @post = Post.find(params[:id])
  # end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to posts_path
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:description, :image)
  end
end
