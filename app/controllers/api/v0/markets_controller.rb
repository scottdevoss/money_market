class Api::V0::MarketsController < ApplicationController
  def index
    render json: Market.all
  end

  def show
    market = Market.find(params[:id])

    if market
      render json: market
    else 
      render json: {error: "detail: Market #{params[:id]} not found"}
    end
  end
end