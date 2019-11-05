class AddressesController < ApplicationController
  def edit
    @address = current_user.addresses.find(params[:id])
  end

  def update
    @address = current_user.addresses.find(params[:id])
    @address.update(address_params)
    if @address.save
      redirect_to '/profile'
      flash[:success] = ["#{@address.nickname} address has been successfully updated"]
    else
      flash.now[:error] = @address.errors.full_messages
      render :edit
    end
  end

  def destroy
    address = current_user.addresses.find(params[:id])
    address.destroy
    flash[:success] = ["#{address.nickname} address has been successfully deleted"]
    redirect_to '/profile'
  end

  def new
    @address = Address.new
  end

  def create
    @address = current_user.addresses.create(address_params)
    if @address.save
      flash[:success] = ["#{@address.nickname} address has been successfully created"]
      redirect_to '/profile'
    else
      flash.now[:error] = @address.errors.full_messages
      render :new
    end
  end

  private

  def address_params
    params.permit(:nickname, :street, :city, :state, :zip)
  end
end
