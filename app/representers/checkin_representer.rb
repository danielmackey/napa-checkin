class CheckinRepresenter < Napa::Representer
  property :id, type: String
  property :created_at, type: Time
  property :updated_at, type: Time
end
