class Checkin < ActiveRecord::Base
  include Napa::FilterByHash

  belongs_to :user
  belongs_to :business

  validates_presence_of :user, :business

  scope :since, -> (time){ where("created_at > ?", time) }
end
