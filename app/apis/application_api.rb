class ApplicationApi < Grape::API
  format :json
  extend Napa::GrapeExtenders

  mount CheckinsApi => '/checkins'
  mount BusinessesApi => '/businesses'
  mount UsersApi => '/users'

  add_swagger_documentation
end

