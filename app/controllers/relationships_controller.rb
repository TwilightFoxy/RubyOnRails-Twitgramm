class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_relationship, only: [:destroy]

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    redirect_to user_profile_path(@user)
  end

  def destroy
    if @relationship
      @user = @relationship.followed
      current_user.unfollow(@user)
    end
    redirect_to user_profile_path(@user)
  end

  private

  def set_relationship
    @relationship = Relationship.find_by(id: params[:id])
    unless @relationship
      redirect_to root_path, alert: "Отношение не найдено"
    end
  end
end
