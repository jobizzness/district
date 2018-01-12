class Managers::ProjectsController < ActionController::Base
  layout 'manager'
  before_action :authenticate_manager!
  before_action :set_project, only: [:show, :update]

  def index
    @all_projects = Project.sort_by_newest
    @deals_projects = Project.in_work
    @not_approved_projects = Project.not_approved
  end

  def show
    if @project.not_approved?
      @partial = 'approve'
    elsif @project.in_work?
      @partial = 'deals'
    end

    return @project, @partial
  end

  def update
    if @project.update(status: :opened)
      redirect_to managers_projects_path
    else
      redirect_to :back
    end
  end

  private
    def set_project
      @project = Project.find(params[:id])
    end
end
