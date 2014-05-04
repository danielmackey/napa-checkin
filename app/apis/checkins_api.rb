class CheckinsApi < Grape::API

  desc 'Get a list of checkins'
  params do
    optional :user_id, type: Integer, desc: 'ID of user to filter with'
    optional :ids, type: String, desc: 'comma separated checkin ids'
  end
  get do
    checkins = Checkin.filter(declared(params, include_missing: false))
    represent checkins, with: CheckinRepresenter
  end

  desc 'Create an checkin'
  params do
    requires :token, type: String, desc: 'token for user checking in'
    requires :business_id, type: Integer, desc: 'ID of business being checked into'
  end

  post do
    token = Token.find_by_value(params[:token])
    if token
      checkin = Checkin.create(user: token.user, business_id: params[:business_id])
      error!(present_error(:record_invalid, checkin.errors.full_messages)) unless checkin.errors.empty?
      represent checkin, with: CheckinRepresenter
    else
      error!(present_error(:invalid_token, ['invalid token']), 403)
    end
  end

  params do
    requires :id, desc: 'ID of the checkin'
  end
  route_param :id do
    desc 'Get a checkin'
    get do
      checkin = Checkin.find(params[:id])
      represent checkin, with: CheckinRepresenter
    end
  end

end
