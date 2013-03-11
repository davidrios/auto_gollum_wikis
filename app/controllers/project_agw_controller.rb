require_dependency 'user'

class ProjectAgwController < ApplicationController
  unloadable

  before_filter :find_project, :find_repo, :find_wiki, :authorize

  def index
    redirect_to :action => :show, :repo_id => params[:repo_id], :page => "Home"
  end

  def show
    show_page(params[:page])
  end

  private

  def show_page(name)
    if page = @wiki.page(name)
      @page_name = page.name
      @page_title = page.title
      @page_toc = page.toc_data.html_safe
      @page_content = page.formatted_data.html_safe
    else
      render :status => 404
    end
  end

  def find_project
    unless params[:project_id].present?
      render :status => 404
      return
    end

    @project = Project.find(params[:project_id])
  end

  def find_repo
    unless @project.repositories.exists?
      render :status => 404
      return
    end

    unless params[:repo_id].present?
      redirect_to :action => :index, :repo_id => @project.repositories.first(:conditions => ["is_default = ?", true]).identifier
      return
    end

    @repository = @project.repositories.first(:conditions => ["identifier = ?", params[:repo_id]])

    if request.GET[:rev]
      redirect_to :rev => request.GET[:rev]
      return
    end

    @rev = params[:rev] || @repository.default_branch
  end

  def find_wiki
    wikis_subdir = @project.agw_config.wikis_subdir

    @wiki = Gollum::Wiki.new(@repository.url,
                             :base_path => url_for(:action => 'index'),
                             :page_file_dir => wikis_subdir,
                             :ref => @rev)

  end
end
