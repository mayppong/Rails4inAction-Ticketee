require "spec_helper"
  
describe '/api/v2/tickets', type: :api do
  let!( :user ) { FactoryGirl.create( :user ) }
  let!( :project ) { FactoryGirl.create( :project, name: 'Ticketee' ) }
  let!( :token ) { user.authentication_token }  

  before do
    user.permissions.create!( action: "view", thing: project )
  end
  
  context 'index' do
    let( :url ) { "/api/v2/projects/#{project.id}/tickets" }

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

  context 'pagination' do
    before do
      3.times do
        FactoryGirl.create( :ticket, project: project, user: user )
      end
 
      @default_per_page = Kaminari.config.default_per_page
      Kaminari.config.default_per_page = 1
    end
    
    after do
      Kaminari.config.default_per_page = @default_per_page
    end

    it 'gets the first page' do
      get "/api/v2/projects/#{project.id}/tickets.json",
        token: token,
        page: 1

      response.body.should eql(project.tickets.page(1).to_json)
    end

    it 'gets the second page' do
      get "/api/v2/projects/#{project.id}/tickets.json?page=2",
        token: token,
        page: 1

      response.body.should eql(project.tickets.page(2).to_json)
    end
  end

end
