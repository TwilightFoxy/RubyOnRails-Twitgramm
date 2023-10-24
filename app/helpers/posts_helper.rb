module PostsHelper
  def user_like(post)
    post.likes.find_by(user_id: current_user.id)
  end
end
