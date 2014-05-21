class TicketsController < ApplicationController
  before_action :require_signin!
  before_action :set_project
  before_action :set_ticket, only: [:show, :edit, :update, :destroy, :watch]
  before_action :authorize_create!, only: [:new, :create]
  before_action :authorize_update!, only: [:edit, :update]
  before_action :authorize_delete!, only: :destroy

#  caches_action :show, cache_path: ( proc do 
#    project_path( params[:id] ) + "/#{current_user.id}/#{params[:page] || 1 }" )
#  end )
  cache_sweeper :tickets_sweeper, only: [:create, :update, :destroy]

  def new
    @ticket = @project.tickets.build
    @ticket.assets.build
  end
  def create
    if cannot?( :tag, @project )
      params[:ticket].delete( :tag_names )
    end
    @ticket = @project.tickets.build( ticket_params )
    @ticket.user = current_user
    if @ticket.save
      flash[:notice] = 'Ticket has been created.'
      redirect_to [@project, @ticket]
    else
      flash[:alert] = 'Ticket has not been created.'
      render "new"
    end
  end

  def show
    @comment = @ticket.comments.build
    @states = State.all
    fresh_when last_modified: @ticket.updated_at, 
      etag: @ticket.to_s + current_user.id.to_s
  end

  def edit
  end
  def update
    if @ticket.update(ticket_params)
      flash[:notice] = 'Ticket has been updated.'
      redirect_to [ @project, @ticket ]
    else
      flash[:notice] = 'Ticket has not been updated.'
      render action: "edit"
    end
  end
  def destroy
    @ticket.destroy
    flash[:notice] = 'Ticket has been deleted.'
    redirect_to @project
  end

  def search
    @tickets = @project.tickets.search( params[:search] )
    @tickets = @tickets.page( params[:page] ).per(50)
    render "projects/show"
  end

  def watch
    if @ticket.watchers.exists?( current_user )
      @ticket.watchers -= [current_user]
      flash[:notice] = 'You are no longer watching this ticket.'
    else
      @ticket.watchers << current_user
      flash[:notice] = 'You are now watching this ticket.'
    end

    redirect_to project_ticket_path( @ticket.project, @ticket )
  end

  private
  def set_project
    @project = Project.for( current_user ).find( params[:project_id] )
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'The project you were looking for could not be found.'
    redirect_to root_path
  end
  def set_ticket
    @ticket = @project.tickets.find( params[:id] )
  end
  def ticket_params
    params.require( :ticket ).permit( :title, :description, :tag_names,
      assets_attributes: [:asset]
    )
  end
  def authorize_create!
    if !current_user.admin? && cannot?( "create tickets".to_sym, @project )
      flash[:alert] = 'You cannot create tickets on this project.'
      redirect_to @project
    end
  end
  def authorize_update!
    if !current_user.admin? && cannot?( "edit tickets".to_sym, @project )
      flash[:alert] = 'You cannot edit tickets on this project.'
      redirect_to @project
    end
  end
  def authorize_delete!
    if !current_user.admin? && cannot?( "delete tickets".to_sym, @project )
      flash[:alert] = 'You cannot delete tickets from this project.'
      redirect_to @project
    end
  end

end
