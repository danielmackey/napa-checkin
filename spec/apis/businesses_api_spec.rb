require 'spec_helper'

def app
  ApplicationApi
end

describe BusinessesApi do
  include Rack::Test::Methods

  describe 'GET /businesses' do

    it 'lists all businesses' do
      business = FactoryGirl.create(:business)
      get '/businesses'
      expect(last_response.body).to eq({data: [BusinessRepresenter.new(business)]}.to_json)
    end

  end

  describe 'POST /businesses' do

    it 'creates a business with all attributes' do
      post '/businesses', name: 'My Awesome Business', website: 'http://awesomebusiness.biz'
      expect(last_response.status).to eq(201)
    end

    it 'requires name to create a business' do
      post '/businesses'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eq(400)
      expect(response['error']['code']).to eq('api_error')
      expect(response['error']['message']).to eq('name is missing')
    end

  end

  describe 'GET /businesses/:id' do

    it 'returns business according to representer' do
      business = FactoryGirl.create(:business)
      get "/businesses/#{business.id}"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ data: BusinessRepresenter.new(business) }.to_json)
    end

    it 'returns not found if business not valid' do
      get "/businesses/999999999"
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eq(404)
      expect(response['error']['code']).to eq('record_not_found')
      expect(response['error']['message']).to eq('record not found')
    end

  end

  describe 'PUT /businesses/:id' do

    it 'updates a business with valid attributes' do
      business = FactoryGirl.create(:business)
      put "/businesses/#{business.id}", website: 'http://superawesome.biz'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(response['data']['website']).to eq('http://superawesome.biz')
    end

  end

end