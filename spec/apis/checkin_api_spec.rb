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

  end

end
