class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    if @post.likes.where(user_id: current_user.id).blank?
      @like = @post.likes.create(user_id: current_user.id)

      ActionCable.server.broadcast(:post_updates_channel, {
        type: 'new_like',
        post_id: @post.id,
        new_like_count: @post.likes.count
      })

      redirect_to root_path
    else
      redirect_to root_path, alert: 'Вы уже ставили лайк этому посту.'
    end
  end

  def destroy
    @like = Like.find(params[:id])
    post = @like.post

    if @like.user == current_user
      @like.destroy

      ActionCable.server.broadcast(:post_updates_channel, {
        type: 'remove_like',
        post_id: post.id,
        new_like_count: post.likes.count
      })

      redirect_to root_path
    else
      redirect_to root_path, alert: 'Ошибка удаления лайка.'
    end
  end
end
