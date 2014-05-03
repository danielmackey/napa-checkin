class Token < ActiveRecord::Base
  include Napa::FilterByHash

  after_initialize :generate_token

  belongs_to :user

  validates_presence_of :user
  validates :value, presence: true, uniqueness: true

  private

    def generate_token
      self.value ||= Digest::SHA1.hexdigest([Time.now, rand].join)
    end
end
