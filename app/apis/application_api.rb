class ApplicationApi < Grape::API
  format :json
  extend Napa::GrapeExtenders

  mount CheckinsApi => '/checkins'
  mount BusinessesApi => '/businesses'
  mount UsersApi => '/users'
  mount TokensApi => '/tokens'

  add_swagger_documentation
end

