require_dependency 'user'

class ProjectAgwController < ApplicationController
  unloadable

  include Precious::Helpers

  before_filter :find_project, :find_repo, :find_wiki, :authorize

  def index
    redirect_to :action => :show, :repo_id => params[:repo_id], :page => "#{@wikis_subdir}/Home"
  end

  def show
    fullpath = params[:page]
    fullpath = "#{fullpath}.#{params[:format]}" if params[:format].present?
    show_page_or_file(fullpath)
  end

  def history
  end

  def search
  end

  def pages
  end

  private

  def show_page_or_file(fullpath)
    name         = extract_name(fullpath)
    path         = extract_path(fullpath) || '/'

    if page = @wiki.paged(name, path, true)
      @page_name = name
      @page_title = page.title

      page_content = page.formatted_data.gsub(/"#{Regexp.escape url_for(:action => 'index')}\/(.*?\.[^."\/]+)"/) do |s|
        url_for :controller => 'repositories', :id => @project, :repository_id => @repository.identifier, :ref => @rev, :action => 'raw', :path => $1
      end.html_safe

      if @project.agw_config.auto_toc and page.raw_data.index('[[_TOC_]]').nil?
        doc = Nokogiri::XML::DocumentFragment.parse(page_content)
        doc.css('h1:first').each do |h|
          h.add_next_sibling(Nokogiri::XML::DocumentFragment.parse(page.toc_data))
        end
        page_content = doc.to_xhtml
      end 

      @page_content = page_content.html_safe
    elsif @wiki.file(fullpath)
      redirect_to :controller => 'repositories', :id => @project, :repository_id => @repository.identifier, :ref => @rev, :action => 'raw', :path => fullpath
    else
      @notfound = true
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

    unless params[:rev].present?
      redirect_to :rev => @repository.default_branch
      return
    end

    @rev = params[:rev] || @repository.default_branch
  end

  def find_wiki
    @wikis_subdir = @project.agw_config.wikis_subdir

    @wiki = Gollum::Wiki.new(@repository.url,
                             :base_path => url_for(:action => 'index'),
                             :page_file_dir => @wikis_subdir,
                             :ref => @rev)

  end
end
