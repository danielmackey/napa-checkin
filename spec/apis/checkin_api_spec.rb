require 'spec_helper'

def app
  ApplicationApi
end

describe CheckinsApi do
  include Rack::Test::Methods

  let(:user) { FactoryGirl.create(:user) }
  let(:business) { FactoryGirl.create(:business) }

  describe 'GET /checkins' do

    it 'returns a list of checkins' do
      checkin = Checkin.create(user: user, business: business)
      get '/checkins'
      expect(last_response.body).to eq({data: [CheckinRepresenter.new(checkin)]}.to_json)
    end

  end

  describe 'POST /checkins' do

    it 'creates a valid checkin' do
      post '/checkins', user_id: user.id, business_id: business.id
      expect(last_response.status).to eq 201
    end

    it 'requires a valid user id' do
      post '/checkins', business_id: business.id
      expect(last_response.status).to eq 400
    end

    it 'requires a valid business id' do
      post '/checkins', user_id: user.id
      expect(last_response.status).to eq 400
    end

    it 'does not allow repeat checkins' do
      # first checkin succeeds
      post '/checkins', user_id: user.id, business_id: business.id
      expect(last_response.status).to eq 201

      # try again, right after
      post '/checkins', user_id: user.id, business_id: business.id
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eq 500
      expect(response['error']['code']).to eq('record_invalid')
      expect(response['error']['message']).to include('already recently checked in')
    end

  end

  describe 'GET /checkins/:id' do

    it 'returns an existing checkin' do
      checkin = Checkin.create(user: user, business: business)
      get "/checkins/#{checkin.id}"
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      expect(response['data']['user_id']).to eq(user.id)
      expect(response['data']['business_id']).to eq(business.id)
    end

    it 'returns 404 for non-existant checkin' do
      get "/checkins/99999999"
      expect(last_response.status).to eq(404)
    end

  end

end
