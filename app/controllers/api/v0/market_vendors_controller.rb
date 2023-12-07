class Api::V0::MarketVendorsController < ApplicationController
  def create
    market_vendor = MarketVendor.create!(market_vendor_params)
    render json: MarketVendorSerializer.new(market_vendor), status: 201
  end

  def destroy
    market_vendor = MarketVendor.find_by(market_vendor_params)
    if market_vendor.nil?
      render json: ErrorSerializer.new(ErrorMessage.new("No MarketVendor with market_id=#{market_vendor_params[:market_id]} AND vendor_id=#{market_vendor_params[:vendor_id]} exists", 404))
        .serialize_json, status: :not_found
    else
      render json: MarketVendor.delete(market_vendor), status: 204
    end
  end

  private

    def market_vendor_params
      params.require(:market_vendor).permit(:market_id, :vendor_id)
    end
end