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
    desc 'Get an checkin'
    get do
      checkin = Checkin.find(params[:id])
      represent checkin, with: CheckinRepresenter
    end

    desc 'Update an checkin'
    params do
    end
    put do
      # fetch checkin record and update attributes.  exceptions caught in app.rb
      checkin = Checkin.find(params[:id])
      checkin.update_attributes!(declared(params, include_missing: false))
      represent checkin, with: CheckinRepresenter
    end
  end

end
