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

end
