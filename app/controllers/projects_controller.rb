class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_to_root, only: [:new, :create], unless: :can_posting?
  before_action :set_project, only: [:show, :edit]
  before_action :data_filter, only: [:index, :filter_projects]

  def index
  end

  def filter_projects
    html = render_to_string partial: 'shared/project', collection: @projects
    render json: { all: @all, count: @count, html: html }, status: :ok
  end

  def show
    if @project.user == current_user
      @bids, @bids_partial = @project.bid_win? ? [@project.bid, 'show'] : [@project.bids, 'list']
    elsif current_user && @project.bids.where(user_id: current_user.id).first
      @bids = @project.bids.where(user_id: current_user.id).first
      @bids_partial = 'show'
    else
      @bids = @project.bids.build
      @bids_partial = 'new'
    end
    return @project, @bids, @bids_partial
  end

  def new
    @project = Project.new
    @project.build_step1
    @project.build_step2
    @project.build_step3
    @project.build_step4
    @project.attachments.build
    @company = current_user.company
    @empty_contacts = []
    %w(city state zip country phone email website address1 address2).each do |field|
      @empty_contacts << field unless @company[field].present?
    end
  end

  def create
    if params[:company].present? && current_user.company.update(company_params) || params[:company].nil?
      if project_params[:step4_attributes].present?
        unless project_params[:step4_attributes][:contact_city].present?
          params[:project][:step4_attributes].merge!(contact_city: company_params[:city])
        end

        unless project_params[:step4_attributes][:contact_state].present?
          params[:project][:step4_attributes].merge!(contact_state: company_params[:state])
        end

        unless project_params[:step4_attributes][:contact_zip].present?
          params[:project][:step4_attributes].merge!(contact_zip: company_params[:zip])
        end
      else
        params[:project].merge!({ step4_attributes: { contact_city: company_params[:city],
                                                           contact_state: company_params[:state],
                                                           contact_zip: company_params[:zip] } })
      end

      @project = current_user.projects.new project_params
      if @project.save        
        Mail::CreateProject.call @project, current_user.company
        redirect_to company_url(tab: :projects), notice: 'Your project sent to manager for approval'
      else
        render :new
      end
    else
      render :new
    end
  end

  def edit
    @company = current_user.company
    (3 - @project.attachments.count).times { @project.attachments.build }
  end

  def update
    @project = current_user.projects.find(params[:id])
    if @project.update_attributes project_params
      redirect_to project_path(@project)
    else
      render :back
    end
  end

  def destroy
    project = current_user.projects.find params[:id]
    if project.destroy
      redirect_to projects_path, notice: 'Project is successfully deleted'
    else
      redirect_to :back, alert: 'Somthing went wrong'
    end
  end

  def search
    if params[:query].present?
      projects = Project.find_projects_by_data params[:query]
      html = render_to_string partial: 'shared/project', collection: projects
      render json: { html: html }, status: :ok
    end
  end

  private
    def project_params
      params.require(:project).permit(
          step1_attributes: [:overall_of_budget, :business_type],
          step2_attributes: [:type_of_product, :samples_number, :samples_date, :how_many_styles,
                             :units_per_style, :made_in_country, :completion_date, :fabrics, 
                             :artwork, :number_of_color_ways, :size_range, :desired_trims, 
                             :made_production, :distribution],
          step3_attributes: [:check_type_branding, :check_type_creative_direction, :check_type_design,
                             :check_type_technical_design, :check_type_sampling, :check_type_production,
                             :check_type_website, :check_type_social, :additional_info
                            ],
          step4_attributes: [:contact_city, :contact_state, :contact_zip],
          attachments_attributes: [:id, :attachment, :_destroy]
        )
    end

    def company_params
      params.require(:company).permit(:city, :state, :zip, :country, :phone, :email, :website, :address1, :address2)
    end

    def data_filter
      @max = 18

      params[:limit] = @max unless params[:limit].present?
      params[:offset] = 0 unless params[:offset].present?

      @projects = Project.includes(:step2, :bid).approved
      @projects = @projects.opened if params[:show] == 'opened'
      @projects = @projects.my(current_user.id) if params[:show] == 'my'
      @projects = @projects.sort_by_newest unless params[:order] == 'oldest'
      @projects = @projects.sort_by_oldest if params[:order] == 'oldest'

      @all = @projects.count - params[:offset].to_i
      @projects = @projects.limit("#{params[:limit].to_i}").offset(params[:offset])
      @count = @projects.count

      return @projects, @all, @count, @max
    end

    def set_project
      @project ||= Project.find(params[:id])
    end

    def can_posting?
      current_user.idea?
    end

    def redirect_to_root
      redirect_to root_path, notice: 'You are not idea maker'
    end
end
