require 'spec_helper'

describe Token do

  let(:user) { FactoryGirl.create(:user) }

  describe :validations do

    it 'creates a token with a valid user' do
      token = Token.create(user: user)
      expect(token.valid?).to be true
      expect(token.persisted?).to be true
    end

  end

  describe :token do

    it 'generate the token value automatically' do
      token = Token.new(user: user)
      expect(token.value).not_to be nil
    end

  end

end