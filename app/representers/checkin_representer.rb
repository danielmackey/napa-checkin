class CheckinRepresenter < Napa::Representer
  property :id, type: String
  property :user_id, type: Integer
  property :business_id, type: Integer
  property :created_at, type: String
end
