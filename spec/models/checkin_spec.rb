require 'spec_helper'

describe Checkin do

  describe :validations do

    let(:user) { FactoryGirl.create(:user) }
    let(:business) { FactoryGirl.create(:business) }

    it 'is valid if user and business is present' do
      checkin = Checkin.new(user: user, business: business)
      expect(checkin.valid?).to be true
    end

    it 'is invalid if no user is present' do
      checkin = Checkin.new(business: business)
      expect(checkin.valid?).to be false
    end

    it 'is invalid if no business is present' do
      checkin = Checkin.new(user: user)
      expect(checkin.valid?).to be false
    end

    describe 'recent checkins' do

      it 'is valid if user has already checked more than 5 minute ago' do
        Timecop.freeze(1.hour.ago) do
          Checkin.create(user: user, business: business)
        end
        new_checkin = Checkin.new(user: user, business: business)
        expect(new_checkin.valid?).to be true
      end

      it 'is invalid if user has already checked less than 5 minute ago' do
        Timecop.freeze(3.minutes.ago) do
          Checkin.create(user: user, business: business)
        end
        new_checkin = Checkin.new(user: user, business: business)
        expect(new_checkin.valid?).to be false
      end

    end

  end

end