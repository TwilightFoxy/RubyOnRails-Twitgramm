class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.html { redirect_to root_path(anchor: "post-#{@post.id}"), notice: 'Комментарий успешно добавлен.' }

        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: 'Ошибка при добавлении комментария.' }
        format.js { render 'error' }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post

    # Проверяем права пользователя на удаление комментария
    if @comment.user == current_user
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to root_path(anchor: "post-#{@post.id}"), notice: 'Комментарий успешно удален.' }
        format.js
      end
    else
      redirect_to root_path, alert: 'У вас нет прав на удаление этого комментария.'
    end
  end



  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
