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

end
