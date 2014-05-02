class UsersApi < Grape::API
  desc 'Get a list of users'
  params do
    optional :ids, type: String, desc: 'comma separated user ids'
  end
  get do
    users = User.filter(declared(params, include_missing: false))
    represent users, with: UserRepresenter
  end

  desc 'Create an user'
  params do
    requires :name, type: String, desc: 'user name'
    requires :email, type: String, desc: 'user email'
  end

  post do
    user = User.create(declared(params, include_missing: false))
    error!(present_error(:record_invalid, user.errors.full_messages)) unless user.errors.empty?
    represent user, with: UserRepresenter
  end

  params do
    requires :id, desc: 'ID of the user'
  end
  route_param :id do
    desc 'Get an user'
    get do
      user = User.find(params[:id])
      represent user, with: UserRepresenter
    end

    desc 'Update an user'
    params do
      optional :name, type: String, desc: 'user name'
      optional :email, type: String, desc: 'user email'
    end
    put do
      # fetch user record and update attributes.  exceptions caught in app.rb
      user = User.find(params[:id])
      user.update_attributes!(declared(params, include_missing: false))
      represent user, with: UserRepresenter
    end

    desc 'Get list of checkins for user'
    get :checkins do
      user = User.find(params[:id])
      checkins = Checkin.filter(user: user)
      represent checkins, with: CheckinRepresenter
    end
  end
end
