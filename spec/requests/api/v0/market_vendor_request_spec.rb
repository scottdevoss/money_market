require "rails_helper"

describe "MarketVendors API" do
  it "creates a market vendor" do
    market = create(:market)
    vendor = create(:vendor)

    market_vendor_params = ({
      market_id: market.id,
      vendor_id: vendor.id
    })

    headers = {'CONTENT_TYPE' => 'application/json'}

    post '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor: market_vendor_params)
    created_market_vendor = MarketVendor.last

    expect(response).to be_successful
    expect(created_market_vendor.market_id).to eq(market_vendor_params[:market_id])
    expect(created_market_vendor.vendor_id).to eq(market_vendor_params[:vendor_id])
  end

  it 'can delete a market_vendor' do
    market = create(:market)      
    vendor = create(:vendor)
    market_vendor = create(:market_vendor, market: market, vendor: vendor)
    market_vendor_info = ({
      market_id: market.id,
      vendor_id: vendor.id
    })
    headers = {'CONTENT_TYPE' => 'application/json'}

    expect(MarketVendor.count).to eq(1)

    delete '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor: market_vendor_info)

    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect(MarketVendor.count).to eq(0)
    expect{MarketVendor.find(market_vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "delete will gracefully handle if a market_vendor for given ids does not exist" do
    market = create(:market)
    vendor = create(:vendor)
    market_vendor_info = ({
                    market_id: market.id,
                    vendor_id: vendor.id
                  })
    headers = {'CONTENT_TYPE' => 'application/json'}

    delete '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor: market_vendor_info)

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq('404')
    expect(data[:errors].first[:title]).to eq("No MarketVendor with market_id=#{market.id} AND vendor_id=#{vendor.id} exists")
  end
end