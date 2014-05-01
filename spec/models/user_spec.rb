require 'spec_helper'

describe User do

  describe :validations do

    it 'is valid with required attributes' do
      user = User.new(name: 'Daniel Mackey', email: 'daniel@danielmackey.com')
      expect(user.valid?).to be true
    end

    it 'is invalid without a name' do
      user = User.new(email: 'daniel@danielmackey.com')
      expect(user.valid?).to be false
    end

    it 'is invalid without an email' do
      user = User.new(name: 'Daniel Mackey')
      expect(user.valid?).to be false
    end

  end

end
