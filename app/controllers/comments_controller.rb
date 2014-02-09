class CommentsController < ApplicationController

  before_action :require_signin!
  before_action :find_ticket

  def create
    if cannot?( :"change states", @ticket.project ) 
      params[:comment].delete( :state_id )
    end

    @comment = @ticket.comments.build( comment_params )
    @comment.user = current_user
    if @comment.save
      flash[:notice] = 'Comment has been created.'
      redirect_to [ @ticket.project, @ticket ]
    else
      flash[:notice] = 'Comment has not been created.'

      @states = State.all
      render template: "tickets/show"
    end
  end

  private

    def find_ticket
      @ticket = Ticket.find( params[:ticket_id] )
    end

    def comment_params
      params.require( :comment ).permit( :text, :state_id, :tag_names )
    end
end
