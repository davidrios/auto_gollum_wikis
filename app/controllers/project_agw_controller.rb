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
    return redirect_to(:path => @wikis_subdir) unless params[:path].present? and (params[:path] == @wikis_subdir or params[:path].start_with?(@wikis_subdir + "/"))
    show_pages(params[:path])
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
        page_content.sub! "</h1>", "</h1>#{page.toc_data}"
      end 

      @page_content = page_content.html_safe
      @raw_path = "#{path}/#{page.filename}"
    elsif @wiki.file(fullpath)
      return redirect_to :controller => 'repositories', :id => @project, :repository_id => @repository.identifier, :ref => @rev, :action => 'raw', :path => fullpath
    else
      @notfound = true
      render :status => 404
    end
  end

  def show_pages(path)
    @path        = path
    wiki = Gollum::Wiki.new(@repository.url,
                            :base_path => url_for(:action => 'index'),
                            :page_file_dir => @path,
                            :ref => @rev)
    results     = wiki.pages

    @breadcrumb =
      if @path
        path = Pathname.new(@path)
        breadcrumb = ['']
        path.descend do |crumb|
          title = crumb.basename

          if title == path.basename
            breadcrumb << title
          else
            breadcrumb << %{<a href="#{url_for :path => crumb}">#{title}</a>}
          end
        end

        breadcrumb.join(" / ")
      else
        @wikis_subdir
      end
      .html_safe

    @has_results = !results.empty?

    @files = []
    @folders = []

    if @has_results
      results.map { |page|
        page_path = page.path.sub(/^#{@path}\//,'')

        if page_path.include?('/')
          folder      = page_path.split('/').first
          folder_path = @path ? "#{@path}/#{folder}" : folder
          {:path => folder_path, :name => folder, :type => :folder}
        elsif page_path != ".gitkeep"
          {:path => page.escaped_url_path, :name => page.name, :type => :file}
        end
      }
      .compact
      .uniq
      .sort { |a, b| a[:name] <=> b[:name] }
      .each { |item|
        @folders << item if item[:type] == :folder
        @files << item if item[:type] == :file
      }
    end

    render :status => 404 unless @has_results
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
