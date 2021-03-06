class BusinessesApi < Grape::API
  desc 'Get a list of businesses'
  params do
    optional :ids, type: String, desc: 'comma separated business ids'
  end
  get do
    businesses = Business.filter(declared(params, include_missing: false))
    represent businesses, with: BusinessRepresenter
  end

  desc 'Create an business'
  params do
    requires :name, type: String, desc: 'business name'
    optional :website, type: String, desc: 'business website'
  end

  post do
    business = Business.create(declared(params, include_missing: false))
    error!(present_error(:record_invalid, business.errors.full_messages)) unless business.errors.empty?
    represent business, with: BusinessRepresenter
  end

  params do
    requires :id, desc: 'ID of the business'
  end
  route_param :id do
    desc 'Get an business'
    get do
      business = Business.find(params[:id])
      represent business, with: BusinessRepresenter
    end

    desc 'Update an business'
    params do
      optional :name, type: String, desc: 'business name'
      optional :website, type: String, desc: 'business website'
    end
    put do
      # fetch business record and update attributes.  exceptions caught in app.rb
      business = Business.find(params[:id])
      business.update_attributes!(declared(params, include_missing: false))
      represent business, with: BusinessRepresenter
    end

    desc 'Get list of checkins for business'
    get :checkins do
      business = Business.find(params[:id])
      checkins = Checkin.filter(business: business)
      represent checkins, with: CheckinRepresenter
    end
  end
end
