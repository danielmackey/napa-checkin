class Token < ActiveRecord::Base
  include Napa::FilterByHash

  before_validation :generate_token, on: :create

  belongs_to :user

  validates_presence_of :user
  validates :value, presence: true, uniqueness: true

  private

    def generate_token
      self.value = Digest::SHA1.hexdigest([Time.now, rand].join)
    end
end
