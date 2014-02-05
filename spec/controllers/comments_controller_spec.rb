require 'spec_helper'

describe CommentsController do

  let( :user ) { FactoryGirl.create( :user ) }
  let( :project ) { Project.create( name: 'Ticketee' ) }
  let( :ticket ) { 
    ticket = project.tickets.build( 
      title: 'State transitions',
      description: 'Can\'t be hacked.'
    )
    ticket.user = user
    ticket.save
    ticket
  }
  let( :state ) { State.create( name: 'New' ) }

  context 'a user without permission to set state' do
    before do
      sign_in( user )
    end

    it 'cannot transition a state by passing through state_id' do
      post :create, {
        comment: { text: 'Hacked!', state_id: state.id },
        ticket_id: ticket.id
      }
      ticket.reload
      ticket.state.should eql( nil )
    end
  end

end
