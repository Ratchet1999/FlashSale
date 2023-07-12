class AddressesController < ApplicationController
  before_action :set_address, only: %i[edit update]
  def new
    @address = Address.new
  end

  def create
    @address = current_user.addresses.build(address_params)
    if @address.save
      redirect_to checkout_order_path(current_order)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @address.update(address_params)
      redirect_to checkout_order_path(current_order)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private 

  def set_address
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:name, :email, :user_id, :city, :state, :country, :pincode)
  end 
end
