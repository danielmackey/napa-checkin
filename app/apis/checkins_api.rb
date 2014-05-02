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
    requires :user_id, type: Integer, desc: 'ID of user checking in'
    requires :business_id, type: Integer, desc: 'ID of business being checked into'
  end

  post do
    checkin = Checkin.create(declared(params, include_missing: false))
    error!(present_error(:record_invalid, checkin.errors.full_messages)) unless checkin.errors.empty?
    represent checkin, with: CheckinRepresenter
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
