class Checkin < ActiveRecord::Base
  include Napa::FilterByHash

  belongs_to :user

  validates_presence_of :user
end
