class Admins::TeamMembersController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  def index
    @team_members = TeamMember.all
  end

  def show
  end

  def new
    @team_member = TeamMember.new
  end

  def edit
  end

  def create
    @team_member = TeamMember.new member_params
    if @team_member.save
      redirect_to admins_team_members_path, notice: 'Member is successfully created'
    else
      redirect_to :back, alert: 'Something went wrong'
    end
  end

  def update
    if @team_member.update_attributes member_params
      redirect_to admins_team_members_path, notice: 'Member is successfully updated'
    else
      redirect_to :back, alert: 'Something went wrong'
    end
  end

  def destroy
    if @team_member.destroy
      redirect_to admins_team_members_path, notice: 'Member is successfully deleted'
    else
      redirect_to :back, alert: 'Something went wrong'
    end
  end

  private
    def set_member
      @team_member = TeamMember.find params[:id]
    end

    def member_params
      params.require(:team_member).permit(:name, :about, :post, :link_fb, :link_li, :link_tw, :link_in, :photo)
    end
end
