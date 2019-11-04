class AddressesController < ApplicationController
  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
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
    address = Address.find(params[:id])
    address.destroy
    flash[:success] = ["#{address.nickname} address has been successfully deleted"]
    redirect_to '/profile'
  end

