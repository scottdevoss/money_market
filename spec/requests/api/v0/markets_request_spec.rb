require 'rails_helper'

describe "Markets API" do
  it "returns all markets" do
    create_list(:market, 10)

    get "/api/v0/markets"

    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)
    
    expect(markets[:data].count).to eq(10)

    markets[:data].each do |market|
      # require 'pry'; binding.pry
      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes][:name]).to be_a(String)

      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes][:street]).to be_a(String)

      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes][:city]).to be_a(String)

      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes][:county]).to be_a(String)

      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes][:state]).to be_a(String)

      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes][:zip]).to be_a(String)

      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes][:lat]).to be_a(String)

      expect(market[:attributes]).to have_key(:lon)
      expect(market[:attributes][:lon]).to be_a(String)

      expect(market[:attributes]).to have_key(:vendor_count)
      expect(market[:attributes][:vendor_count]).to be(nil)
    end
  end

  it "can get one market by its id" do
    market = create(:market)
  
    get "/api/v0/markets/#{market.id}"
  
    market = JSON.parse(response.body, symbolize_names: true)
  
    expect(response).to be_successful

    market = market[:data]
    
    expect(market).to have_key(:id)
    expect(market[:id]).to be_a(String)
  
    expect(market[:attributes]).to have_key(:name)
    expect(market[:attributes][:name]).to be_a(String)
  
    expect(market[:attributes]).to have_key(:street)
    expect(market[:attributes][:street]).to be_a(String)

    expect(market[:attributes]).to have_key(:city)
    expect(market[:attributes][:city]).to be_a(String)

    expect(market[:attributes]).to have_key(:county)
    expect(market[:attributes][:county]).to be_a(String)

    expect(market[:attributes]).to have_key(:state)
    expect(market[:attributes][:state]).to be_a(String)

    expect(market[:attributes]).to have_key(:zip)
    expect(market[:attributes][:zip]).to be_a(String)

    expect(market[:attributes]).to have_key(:lat)
    expect(market[:attributes][:lat]).to be_a(String)

    expect(market[:attributes]).to have_key(:lon)
    expect(market[:attributes][:lon]).to be_a(String)

    expect(market[:attributes]).to have_key(:vendor_count)
    expect(market[:attributes][:vendor_count]).to be(nil)
  end

  describe 'sad paths' do
    it "will gracefully handle if a market id doesn't exist" do
      get "/api/v0/markets/0"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=0")
    end
  end

  it "gets all vendors for a market" do
    market = create(:market)
    vendors = create_list(:vendor, 3)

    market.vendors << vendors

    get "/api/v0/markets/#{market.id}/vendors"

    vendors = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    vendors = vendors[:data]

  end
end