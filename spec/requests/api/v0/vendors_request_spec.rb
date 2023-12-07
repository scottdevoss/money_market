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

  it "gets one vendor" do
    vendor = create(:vendor)

    get "/api/v0/vendors/#{vendor.id}"

    vendor = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    vendor = vendor[:data]

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

  it "show will gracefully handle if a vendor id doesn't exist" do
    get '/api/v0/vendors/0'

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq('404')
    expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=0")
  end

  it "can create a new vendor" do
    vendor_params = ({
      name: 'Murder on the Orient Express',
      description: 'Agatha Christie',
      contact_name: 'mystery',
      contact_phone: 'Filled with suspense.',
      credit_accepted: true
    })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)

    created_vendor = Vendor.last 

    expect(response).to be_successful

    expect(response.status).to eq(201)
    
    expect(created_vendor.name).to eq(vendor_params[:name])
    expect(created_vendor.description).to eq(vendor_params[:description])
    expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
    expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
    expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
  end

  it 'create will gracefully handle if invalid info is entered' do
    vendor_params = ({
                    name: 'Murder on the Orient Express',
                    description: 'a mystery',
                    credit_accepted: true
                  })
    headers = {'CONTENT_TYPE' => 'application/json'}
  
    post '/api/v0/vendors', headers: headers, params: JSON.generate(vendor: vendor_params)

    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("400")
    expect(data[:errors].first[:title]).to eq("Validation failed: Contact name can't be blank, Contact phone can't be blank")
  end

  it "can update an existing vendor" do
    id = create(:vendor).id

    previous_name = Vendor.last.name
    vendor_params = {
      name: "Walmart"
    }

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
    vendor = Vendor.find_by(id: id)

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(vendor.name).to_not eq(previous_name)
    expect(vendor.name).to eq("Walmart")
  end

  it 'update will gracefully handle if invalid info is entered' do
    vendor = create(:vendor)
    
    vendor_params = ({
                    name: '',
                    description: 'a mystery'
                  })
    headers = {'CONTENT_TYPE' => 'application/json'}
  
    patch "/api/v0/vendors/#{vendor.id}", headers: headers, params: JSON.generate(vendor: vendor_params)
     
    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("400")
    expect(data[:errors].first[:title]).to eq("Validation failed: Name can't be blank")
  end

  it "update will gracefully handle if a vendor id doesn't exist" do
    vendor_params = ({
      description: 'a mystery',
      contact_phone: '734-9282',
      credit_accepted: true
    })
    headers = {'CONTENT_TYPE' => 'application/json'}

    patch '/api/v0/vendors/123123123', headers: headers, params: JSON.generate(vendor: vendor_params)

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq('404')
    expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=123123123")
  end

  it "deletes a vendor" do
    vendor = create(:vendor)

    expect(Vendor.count).to eq(1)

    delete "/api/v0/vendors/#{vendor.id}"

    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect(Vendor.count).to eq(0)
    expect{Vendor.find(vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end