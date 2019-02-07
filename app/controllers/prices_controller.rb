class PricesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_price, only: [:edit, :update, :destroy]

  def index
    @prices = Price.all
    @price = Price.new
  end

  def edit
  end

  def create
    @price = Price.new(price_params)
    respond_to do |format|
      if @price.save
        format.html { redirect_to(prices_path, :notice => 'Preis erfolgreich gespeichert.') }
        format.json { head :ok }
        format.js {render layout: false}
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @price.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @price.update(price_params)
        format.html { redirect_to(prices_path, :notice => 'Preis erfolgreich geändert.') }
        format.json { head :ok }
        format.js {render layout: false}
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @price.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @price.destroy
    respond_to do |format|
        format.js
    end
  end

  private
    def set_price
      @price = Price.find(params[:id])
    end

    def price_params
      params.require(:price).permit(:eid, :artikel, :preis)
    end
end
