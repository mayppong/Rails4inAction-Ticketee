require "spec_helper"

describe "/api/v2/projects", type: :api do
  let!( :user ) { FactoryGirl.create( :user ) }
  let!( :token ) { user.authentication_token }
  let!( :project ) { FactoryGirl.create( :project ) }

  before do 
    user.permissions.create!(action: "view", thing: project)
  end

  context 'projects viewable by this user' do
    let!( :url ) { "api/v2/projects" }
    let!( :options ) { { except: :name, methods: :title } } 

    it 'json' do
      get "#{url}.json", token: token

      body = Project.for(user).to_json(options)
      expect(response.body).to eq( body )
      response.status.should eql( 200 )
    
      projects = JSON.parse( response.body )
      projects.any? do |p|
        p["title"] == project.name
      end.should be_true

      projects.all? do |p|
        p["name"].blank?
      end.should be_true
    end

    it 'xml' do
      get "#{url}.xml", token: token
      
      body = Project.for(user).to_xml(options)
      response.body.should eql( body )
      projects = Nokogiri::XML( response.body )
      projects.css("project title").text.should eql( 'Example project' )
      projects.css("project name").text.should eql( '' )
    end
  end

end
