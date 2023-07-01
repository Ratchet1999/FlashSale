class UsersController < ApplicationController
  before_action :set_user, only: %i[soft_delete]

  def soft_delete
    @user.discard
    redirect_to admin_users_path, notice: 'Account Deactivated'
  end

  private 

  def set_user
    @user = User.find_by(id: params[:id])
    redirect_to admin_users_path, notice: "User Not found" unless @user
  end
end
