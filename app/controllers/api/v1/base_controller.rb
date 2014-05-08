class Api::V1::BaseController < ActionController::Base

  respond_to :json, :xml

  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user
  before_filter :check_rate_limit

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

    def authorize_admin!
      if !@current_user.admin?
        error = { error: "You must be an admin to do that." }
        warden.custom_failure!
        render params[:format].to_sym => error, status: 401
      end
    end

    def check_rate_limit
      if @current_user.request_count > 100
        error = { error: 'Rate limit exceeded.' }
        respond_with( error, status: 403 )
      else
        @current_user.increment!( :request_count )
      end
    end

end
