require 'rails_helper'

describe "Vendors API" do
  it "gets all vendors for a market" do
    market = create(:market)
    vendors = create_list(:vendor, 3)

    market.vendors << vendors

    get "/api/v0/markets/#{market.id}/vendors"

    vendors = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    vendors = vendors[:data]

    expect(vendors.count).to eq(3)

    vendors.each do |vendor|
      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:name)
      expect(vendor[:attributes][:name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:description)
      expect(vendor[:attributes][:description]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_name)
      expect(vendor[:attributes][:contact_name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_phone)
      expect(vendor[:attributes][:contact_phone]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:credit_accepted)
      expect(vendor[:attributes][:credit_accepted]).to be_a(TrueClass).or be_a(FalseClass)
    end
  end

  it "index will gracefully handle if a market id doesn't exist" do
    get '/api/v0/markets/0/vendors'

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)
    
    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq('404')
    expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=0")
  end
end