class Checkin < ActiveRecord::Base
  include Napa::FilterByHash

  belongs_to :user
  belongs_to :business

  validates_presence_of :user, :business
  validate :no_recent_checkins, on: :create

  scope :since, -> (time){ where("created_at > ?", time) }

  private

    def no_recent_checkins
      return unless user && business
      if Checkin.filter(user: user, business: business).since(5.minutes.ago).any?
        errors.add(:base, 'already recently checked in')
      end
    end
end
