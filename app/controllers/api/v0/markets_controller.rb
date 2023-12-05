class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(Market.find(params[:id]))
    # market = Market.find(params[:id])

    # if market
    #   render json: market
    # else 
    #   render json: {error: "detail: Couldn't find Market with id:: #{params[:id]}"}
    # end
  end
end