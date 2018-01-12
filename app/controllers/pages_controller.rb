class PagesController < ApplicationController
  def about
    @team_members = TeamMember.all
  end

  def contacts
    @data = Ctrl.where(disabled: 0).map { |c| [ c.nm, c.val ] }.to_h
  end

  def tomorrowear    
  end

  def feedback
    # TODO: send email
  end

  def show
    @data = InfoPage.find_by(trans: page_name)
  end
 
  protected
    def page_name
      params[:page] || 'terms'
    end
end
