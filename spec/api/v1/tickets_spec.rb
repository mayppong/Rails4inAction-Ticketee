require "spec_helper"
  
describe '/api/v1/tickets', type: :api do
  let!( :user ) { FactoryGirl.create( :user ) }
  let!( :project ) { FactoryGirl.create( :project, name: 'Ticketee' ) }
  let!( :token ) { user.authentication_token }  

  before do
    user.permissions.create!( action: "view", thing: project )
  end
  
  context 'index' do
    let( :url ) { "/api/v1/projects/#{project.id}/tickets" }

    before do
      5.times do
        FactoryGirl.create( :ticket, project: project, user: user )
      end
    end  

    it 'JSON' do
      get "#{url}.json", token: token
      response.body.should eql( project.tickets.to_json )
    end

    it 'XML' do
      get "#{url}.xml", token: token
      response.body.should eql( project.tickets.to_xml )
    end
  end
end
