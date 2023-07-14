class Admin::CurrenciesController < Admin::BaseController
  def index
    @currencies = Currency.all
  end

  def new
    @currency = Currency.new
  end

  def create
    @currency = Currency.new(currency_params)
    if @currency.save
      redirect_to admin_currencies_path, notice: 'Currency Exchange was successfully added'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def currency_params
    params.require(:currency).permit(conversion_rates: {})
  end
end
