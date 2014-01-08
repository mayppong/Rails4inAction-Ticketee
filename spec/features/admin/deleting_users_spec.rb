require 'spec_helper'

feature 'Deleting users' do

  given!( :admin_user ) { FactoryGirl.create( :admin_user ) }
  given!( :user ) { FactoryGirl.create( :user ) }

  before do
    sign_in_as!( admin_user )
    visit '/'
    click_link 'Admin'
    click_link 'Users'
  end

  scenario 'deleting a user' do
    click_link user.email
    click_link 'Delete User'
    expect( page ).to have_content( 'User has been deleted.' )
  end
  
  scenario 'not allow to delete themselves' do
    click_link admin_user.email
    click_link 'Delete User'
    expect( page ).to have_content( 'You cannot delete yourself!' )
  end

end
    
