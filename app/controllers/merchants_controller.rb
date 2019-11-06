class MerchantsController <ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def new
  end

  def create
    merchant = Merchant.create(merchant_params)
    if merchant.save
      redirect_to merchants_path
    else
      flash[:error] = merchant.errors.full_messages
      render :new
    end
  end

  def edit
    @merchant = Merchant.find(params[:id])
    render_404 if current_user.nil? || current_user.merchant_id != @merchant.id
  end

  def update
    @merchant = Merchant.find(params[:id])
    @merchant.update(merchant_params)
    if @merchant.save
      redirect_to "/merchants/#{@merchant.id}"
    else
      flash[:error] = @merchant.errors.full_messages
      render :edit
    end
  end

  private

  def merchant_params
    params.permit(:name,:address,:city,:state,:zip)
  end

end
