class Admins::ProjectsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @projects = Project.all
  end

  def show
  end

  def new
    @project = Project.new
    @project.build_step1
    @project.build_step2
    @project.build_step3
    @project.build_step4
    @project.attachments.build
  end

  def edit
    (3 - @project.attachments.count).times { @project.attachments.build }
  end

  def create
    @project = Project.new project_params
    if @project.save
      redirect_to admins_projects_path, notice: 'Project is successfully created'
    else
      redirect_to :back, alert: 'Something went wrong'
    end
  end

  def update
    if @project.update_attributes project_params
      redirect_to admins_projects_path, notice: 'Project is successfully updated'
    else
      redirect_to :back, alert: 'Something went wrong'
    end
  end

  def destroy
    if @project.destroy
      redirect_to admins_projects_path, notice: 'Project is successfully deleted'
    else
      redirect_to :back, alert: 'Something went wrong'
    end
  end

  private
    def set_project
      @project = Project.find params[:id]
    end

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
end
