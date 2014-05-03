require 'spec_helper'

def app
  ApplicationApi
end

describe BusinessesApi do
  include Rack::Test::Methods

  let(:user) { FactoryGirl.create(:user) }

  describe 'POST /tokens' do

    it 'creates a token for user with valid creds' do
      post '/tokens', email: user.email, password: user.password
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eq(201)
      expect(response['data']['object_type']).to eq 'token'
      expect(response['data']['value']).to_not be nil
      expect(response['data']['user_id']).to eq user.id
    end

    it 'returns 403 with invalid creds' do
      post '/tokens', email: user.email, password: 'not_the_password'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eq(403)
      expect(response['error']['code']).to eq 'invalid_credentials'
      expect(response['error']['message']).to include 'email and/or password do not match'
    end

    it 'returns a 400 with no credentials passed' do
      post '/tokens'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eq(400)
      expect(response['error']['code']).to eq 'api_error'
      expect(response['error']['message']).to include 'email is missing'
      expect(response['error']['message']).to include 'password is missing'
    end

  end

end