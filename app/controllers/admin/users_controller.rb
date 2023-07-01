class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[show edit update destroy]
  
  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User #{@user.email} was successfully updated."
    else
      render :edit, status: :unprocessable_entity 
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice: "User #{@user.email} was successfully destroyed."
    else
      render :new, status: :unprocessable_entity 
    end
  end

  private 

  def set_user
    @user = User.find_by(id: params[:id])
    redirect_to admin_users_path, notice: "User Not found" unless @user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role)
  end 
end
