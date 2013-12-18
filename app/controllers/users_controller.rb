class UsersController < ApplicationController

  before_action :set_user, only: [ :edit, :show ]

  def new
    @user = User.new
  end

  def create
    @user = User.new( user_params )
    
    if( @user.save )
      flash[ :notice ] = 'You have signed up successfully.'
      redirect_to projects_path
    else
      render :new
    end
  end

  def show
  end
  def view
  end
  
  def update
    @user = User.find( params[:id] )

    if @user.update( user_params )
      flash[:notice] = 'Profile has been updated.'
      redirect_to @user
    else
      render :edit
    end
  end
 
  private

    def set_user
      @user = User.find( params[:id] )
    end
    def user_params
      params.require( :user ).permit( :name, :password, :password_confirmation )
    end 

end
