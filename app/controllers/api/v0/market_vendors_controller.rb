class Api::V0::MarketVendorsController < ApplicationController
  def create
    market_vendor = MarketVendor.create!(market_vendor_params)
    render json: MarketVendorSerializer.new(market_vendor), status: 201
  end

  def destroy
    # require 'pry'; binding.pry
    market_vendor = MarketVendor.find(params[:id])
    render json: MarketVendorSerializer.delete(market_vendor), status: 204
  end

  private

    def market_vendor_params
      params.require(:market_vendor).permit(:market_id, :vendor_id)
    end
end