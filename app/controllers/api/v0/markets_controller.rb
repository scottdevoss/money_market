class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    begin
      render json: MarketSerializer.new(Market.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => exception
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404)).serialize_json, status: :not_found
    end 
    # market = Market.find(params[:id])

    # if market
    #   render json: market
    # else 
    #   render json: {error: "detail: Couldn't find Market with id:: #{params[:id]}"}
    # end
  end
end