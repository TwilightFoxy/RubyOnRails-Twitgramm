class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(profile_params)
      redirect_to profile_path(@user), notice: 'Профиль обновлен!'
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:user).permit(:username, :avatar)
  end

end
