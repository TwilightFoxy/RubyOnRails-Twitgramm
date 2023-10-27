class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = params[:id].present? ? User.find(params[:id]) : current_user

    puts "Параметры ID: #{params[:id]}"
    puts "Текущий пользователь: #{current_user.id}"
    puts "@user ID: #{@user.id}"

    @posts = @user.posts.order(created_at: :desc)
  end





  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      redirect_to profile_path, notice: 'Описание обновлено'
    end
  end


  def index
    if params[:search].present?
      @users = User.where("nickname LIKE ? OR email LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
      @search_info = "Результаты поиска для '#{params[:search]}': #{@users.count} пользователей найдено."
    else
      @users = User.all
      @search_info = "Полный список пользователей."
    end
  end


  def friends
    @friends = current_user.following
    if params[:search].present?
      @friends = @friends.where("username LIKE ? OR email LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
      @search_info = "Результаты поиска для: #{params[:search]}"
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
  end
  def user_params
    params.require(:user).permit(:description, :nickname, :avatar)
  end
end
