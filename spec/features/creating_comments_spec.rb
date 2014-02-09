require 'spec_helper'

feature 'Creating comments' do
  let!( :user ) { FactoryGirl.create( :user ) }
  let!( :project ) { FactoryGirl.create( :project ) }
  let!( :ticket ) { FactoryGirl.create( :ticket, project: project, user: user ) }
  let!( :state ) { FactoryGirl.create( :state, name: 'Open' ) }

  before do
    define_permission!( user, "view", project )
    sign_in_as!( user )
    visit '/'
    click_link project.name
  end
  
  feature 'without permission to the states' do
    before do
      click_link ticket.title 
    end

    scenario 'creating a comment' do
      fill_in 'Text', with: 'Added a comment!'
      click_button 'Create Comment'
      page.should have_content( 'Comment has been created.' )
      within( '#comments' ) do
        page.should have_content( 'Added a comment!' )
      end
    end

    scenario 'creating an invalid comment' do
      click_button 'Create Comment'
      page.should have_content( 'Comment has not been created.' )
      page.should have_content( 'Text can\'t be blank' )
    end

    scenario 'a user without permission cannot change the state' do 
      find_element = lambda { find( "#comment_state_id" ) }
      message = 'Expected not to see #comment_state_id, but did.'
      find_element.should( raise_error( Capybara::ElementNotFound ), message )
    end
  end

  feature 'with permission to states' do
    before do
      define_permission!( user, "change states", project )
      click_link ticket.title
    end

    scenario 'changing a ticket\'s state' do
      fill_in 'Text', with: 'This is a real issue'
      select 'Open', from: 'State'
      click_button 'Create Comment'
      page.should have_content( 'Comment has been created' )
      within( "#ticket .state" ) do
        page.should have_content( 'Open' )
      end
      within( "#comments" ) do
        page.should have_content( 'State: Open' )
      end
    end
    scenario 'adding a tag to a ticket' do
      within( "#ticket #tags" ) do
        page.should_not have_content( "bug" )
      end

      fill_in 'Text', with: 'Adding the bug tag'
      fill_in 'Tags', with: 'bug'
      click_button 'Create Comment'

      page.should have_content( 'Comment has been created.' )
      within( "#ticket #tags" ) do
        page.should have_content( "bug" )
      end
    end  
  end

end
