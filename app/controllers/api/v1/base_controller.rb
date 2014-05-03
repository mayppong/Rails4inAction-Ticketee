class Api::V1::BaseController < ActionController::Base

  respond_to :json

  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user

  private

    def authenticate_user
      @current_user = User.find_by_authentication_token( params[:token] )
      unless @current_user
        respond_with({ error: 'Token is invalid.' })
      end
    end
    def current_user
      @current_user
    end

    def authenticate_user_from_token!
      user_email = params[:user_email].presence
      user = user_email && User.find_by_email( user_email )

      if user && Devise.secure_compare( user.authentication_token, params[:user_token] )
        sign_in user, store: false
      end
    end
end
