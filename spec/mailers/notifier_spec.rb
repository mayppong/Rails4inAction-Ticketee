require "spec_helper"

describe Notifier do

  context 'comment_updated' do
    let!(:project) { FactoryGirl.create(:project) }
    let!(:ticket_owner) { FactoryGirl.create(:user) }
    let!(:ticket) { FactoryGirl.create( :ticket, 
      project: project, 
      user: ticket_owner
    )}

    let!(:commenter) { FactoryGirl.create(:user) }
    let(:comment) {
      Comment.new({ 
        ticket: ticket,
        user: commenter,
        text: "Test comment"
      }, without_protection: true)
    }
    let(:email) {
      Notifier.comment_updated( comment, ticket_owner )
    }

    it 'sends out an email notification about a new comment' do
      email.to.should include( ticket_owner.email )
      title = "#{ticket.title} for #{project.name} has been updated."
      email.body.should include( title )
      email.body.should include( "#{comment.user.email} wrote:" )
      email.body.should include( comment.text )
    end
  end

end
