require 'spec_helper'

feature 'Creating comments' do
  let!( :user ) { FactoryGirl.create( :user ) }
  let!( :project ) { FactoryGirl.create( :project ) }
  let!( :ticket ) { FactoryGirl.create( :ticket, project: project, user: user ) }

  before do
    define_permission!( user, "view", project )

    sign_in_as!( user )
    visit '/'
    click_link project.name
  end

  scenario 'creating a comment' do
    click_link ticket.title
    fill_in 'Text', with: 'Added a comment!'
    click_button 'Create Comment'
    page.should have_content( 'Comment has been created.' )
    within( '#comments' ) do
      page.should have_content( 'Added a comment!' )
    end
  end

  scenario 'creating an invalid comment' do
    click_link ticket.title
    click_button 'Create Comment'
    page.should have_content( 'Comment has not been created.' )
    page.should have_content( 'Text can\'t be blank' )
  end

end
