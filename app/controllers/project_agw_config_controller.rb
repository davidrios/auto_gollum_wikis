class ProjectAgwConfigController < ApplicationController
  menu_item :settings
  unloadable

  before_filter :find_project, :authorize

  def index
    redirect_to :action => :show
  end

  def create
    update
  end

  def update
    project_agw_config = @project.agw_config
    project_agw_config.attributes = params[:project_agw_config]
    if project_agw_config.save
      flash[:notice] = t(:project_agw_config_updated)
    else
      flash[:error] = t(:project_agw_config_update_error)
    end
    redirect_to(:controller=>'projects', :action=>'settings', :id=>@project, :tab=>'project_agw_config')
  end

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
