require 'spec_helper'

describe Comment do
  # pending "add some examples to (or delete) #{__FILE__}"
  let( :user ) { FactoryGirl.create( :user ) }
  let( :project ) { FactoryGirl.create( :project ) } 

  before do
    @ticket = FactoryGirl.create( :ticket, project: project, user: user )
    @ticket.watchers << user
  end

  it 'notifies people through a delayed job' do
    Delayed::Job.count.should eql(0)
    @ticket.comments.create!( 
      ticket: @ticket, 
      text: 'This is a comment.', 
      user: @ticket.user )

    Delayed::Job.count.should eql(1)
    
    Delayed::Worker.new.work_off
    Delayed::Job.count.should eql(0)
    
    email = ActionMailer::Base.deliveries.last
binding.pry
    email.to.should eql(user.email)
  end

end
