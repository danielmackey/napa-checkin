class User < ActiveRecord::Base
  include Napa::FilterByHash

  has_many :checkins
  validates_presence_of :name, :email
end
