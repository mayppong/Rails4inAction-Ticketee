class Api::V1::ProjectsController < Api::V1::BaseController

  before_filter :authorize_admin!, except: [:index, :show]

  def index
    respond_with( Project.all )
  end

  def create 
    project = Project.new( project_params )
    if project.save
      respond_with( project, location: api_v1_project_path(project) )
    else
      respond_with( project )
    end
  end

  private

    def project_params
      project = params[:project]
      project.permit( :name, :description ) unless project == nil
    end
end
