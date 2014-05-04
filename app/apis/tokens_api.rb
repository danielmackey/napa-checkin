class TokensApi < Grape::API

  desc 'Create a token'
  params do
    requires :email, type: String, desc: 'email address of user'
    requires :password, type: String, desc: 'password of user'
  end
  post do
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      token = Token.create(user: user)
      error!(present_error(:record_invalid, token.errors.full_messages)) unless token.errors.empty?
      represent token, with: TokenRepresenter
    else
      error!(present_error(:invalid_credentials, ['email and/or password do not match']), 403)
    end
  end

  params do
    requires :value, desc: 'ID of the token'
  end
  route_param :value do

    desc 'Destroy a token'
    delete do
      token = Token.find_by_value!(params[:value])
      token.destroy
    end
  end
end
