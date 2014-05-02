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
      get '/checkins', user_id: user.id
      expect(last_response.body).to eq({data: [CheckinRepresenter.new(checkin)]}.to_json)
    end

    it 'returns an error if no user id sent' do
      get '/checkins'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eq 400
      expect(response['error']['code']).to eq 'api_error'
      expect(response['error']['message']).to eq 'user_id is missing'
    end

  end

end
