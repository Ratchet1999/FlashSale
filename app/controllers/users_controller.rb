class UsersController < ApplicationController
  before_action :set_user, only: %i[deactivate]

  def deactivate
    @user.discard
    redirect_to admin_users_path, notice: 'Account Deactivated'
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path
    else
      redirect_to root_path, notice: 'Unexpected Error during currency conversion'
    end
  end

  private 

  def set_user
    @user = User.find_by(id: params[:id])
    redirect_to admin_users_path, notice: "User Not found" unless @user
  end

  def user_params
    params.require(:user).permit(:currency_preference)
  end
end
