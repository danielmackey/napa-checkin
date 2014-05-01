class User < ActiveRecord::Base
  has_many :checkins
  validates_presence_of :name, :email
end
