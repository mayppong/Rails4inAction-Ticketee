require "spec_helper"

describe "/api/v1/projects", type: :api do
  let!( :user ) { FactoryGirl.create( :user ) }
  let!( :token ) { user.authentication_token }
  let!( :project ) { FactoryGirl.create( :project ) }

  before do 
    user.permissions.create!(action: "view", thing: project)
  end

  context 'projects viewable by this user' do
    let!( :url ) { "api/v1/projects" }
    
    it 'json' do
      get "#{url}.json", token: token
      projects_json = Project.all.to_json
      expect(response.body).to eq(projects_json)
      response.status.should eql(200)
    
      projects = JSON.parse( response.body )

      projects.any? do |p|
        p["name"] == project.name
      end.should be_true
    end

    it 'xml' do
      get "#{url}.xml", token: token
      response.body.should eql( Project.for(user).to_xml )
      projects = Nokogiri::XML( response.body )
      projects.css("project name").text.should eql( project.name )
    end
  end

  context 'creating a project' do
    let(:url) { "/api/v1/projects" }
    
    before do
      user.admin = true
      user.save
    end

    it 'successful JSON' do
      post "#{url}.json", token: token, project: { name: "Inspector" }
      
      project = Project.find_by_name!( "Inspector" )
      route = "/api/v1/projects/#{project.id}"

      response.status.should eql( 201 )
      response.headers["Location"].should eql( route )
      response.body.should eql( project.to_json )
    end
    it 'unsucccessful JSON' do
      post "#{url}.json", token: token, project: {}

      response.status.should eql(422)
      errors = { "errors" => {
        "name" => ["can't be blank"]
      }}.to_json
      response.body.should eql(errors)
    end
  end

  context 'show' do
    let( :url ) { "/api/v1/projects/#{project.id}" }

    before do
      FactoryGirl.create( :ticket, project: project )
    end

    it 'JSON' do
      get "#{url}.json", token: token
      project_json = project.to_json( :methods => "last_ticket" )
      response.body.should eql(project_json)
      response.status.should eql(200)
     
      project_response = JSON.parse( response.body )

      ticket_title = project_response["last_ticket"]["title"]
      ticket_title.should_not be_blank
    end
  end

end
