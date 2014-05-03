class User < ActiveRecord::Base
  include Napa::FilterByHash

  has_secure_password

  has_many :checkins

  validates_presence_of :name, :email
  validates_presence_of :password, on: :create
end
