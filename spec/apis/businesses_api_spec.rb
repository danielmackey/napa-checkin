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

  describe "GET /users/:id/checkins" do

    it 'returns a list of checkins for this business' do
      user_1 = FactoryGirl.create(:user, name: 'Jane Smith', email: 'jsmith@yahoo.com')
      user_2 = FactoryGirl.create(:user, name: 'John Doe', email: 'johndoe@gmail.com')
      business = FactoryGirl.create(:business)
      checkin_1 = Checkin.create(user: user_1, business: business)
      checkin_2 = Checkin.create(user: user_2, business: business)

      get "/businesses/#{business.id}/checkins"
      response = JSON.parse(last_response.body)

      expect(last_response.status).to eq(200)
      expect(response['data'].length).to eq(2)
      expect(response['data']).to include(CheckinRepresenter.new(checkin_1).to_hash)
    end

  end

end