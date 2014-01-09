require 'spec_helper'

feature "Viewing projects" do

  given!( :user ) { FactoryGirl.create( :user ) }
  given!( :project ) { FactoryGirl.create( :project ) }

  before do
    sign_in_as!(user)
    define_permission!( user, :view, project )
  end

  scenario "Listing all projects" do
    visit '/'
    click_link project.name
    expect( page.current_url ).to eql( project_url(project) )
  end
end
