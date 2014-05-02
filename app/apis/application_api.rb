class ApplicationApi < Grape::API
  format :json
  extend Napa::GrapeExtenders

  mount CheckinsApi => '/checkins'
  mount BusinessesApi => '/businesses'

  add_swagger_documentation
end

