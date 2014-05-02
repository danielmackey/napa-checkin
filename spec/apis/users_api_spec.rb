require 'spec_helper'

def app
  ApplicationApi
end

describe UsersApi do
  include Rack::Test::Methods

  describe 'GET /users' do

    it 'lists all users' do
      user = FactoryGirl.create(:user)
      get '/users'
      expect(last_response.body).to eq({data: [UserRepresenter.new(user)]}.to_json)
    end

  end

  describe 'POST /users' do

    it 'creates a user with all attributes' do
      post '/users', name: 'Daniel Mackey', email: 'daniel@danielmackey.com'
      expect(last_response.status).to eq(201)
    end

    it 'requires name and email to create a user' do
      post '/users'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eq(400)
      expect(response['error']['code']).to eq('api_error')
      expect(response['error']['message']).to include('name is missing')
      expect(response['error']['message']).to include('email is missing')
    end

  end

  describe 'GET /users/:id' do

    it 'returns user according to representer' do
      user = FactoryGirl.create(:user)
      get "/users/#{user.id}"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ data: UserRepresenter.new(user) }.to_json)
    end

    it 'returns not found if user not valid' do
      get "/users/999999999"
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eq(404)
      expect(response['error']['code']).to eq('record_not_found')
      expect(response['error']['message']).to eq('record not found')
    end

  end

  describe 'PUT /users/:id' do

    it 'updates a user with valid attributes' do
      user = FactoryGirl.create(:user)
      put "/users/#{user.id}", email: 'github@danielmackey.com'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(response['data']['email']).to eq('github@danielmackey.com')
    end

  end

end