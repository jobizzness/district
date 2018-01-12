class CompaniesController < ApplicationController
  def show
    if request.subdomain.present?
      if current_user && current_user.company.address == request.subdomain
        current_user_company
      else
        company = Company.find_by_address request.subdomain
        if company.present?
          @company = company
        else
          redirect_to root_url
        end
      end
    elsif current_user
      current_user_company
    else
      redirect_to root_url
    end

    @subcats_services = Subcategory.where(type_id: 3).collect { |subcat| { id: subcat.id, name: subcat.name, cats: subcat.categories.pluck(:id).join(',') } }
    @subcats_agencies = Subcategory.where(type_id: 4).collect { |subcat| { id: subcat.id, name: subcat.name, cats: subcat.categories.pluck(:id).join(',') } }
    @subcats_type     = Subcategory.where(type_id: 5).collect { |subcat| { id: subcat.id, name: subcat.name, cats: subcat.categories.pluck(:id).join(',') } }
    @subcats_products = Subcategory.where(type_id: 1).collect { |subcat| { id: subcat.id, name: subcat.name, cats: subcat.categories.pluck(:id).join(',') } }
    @subcats_fabrics  = Subcategory.where(type_id: 2).collect { |subcat| { id: subcat.id, name: subcat.name, cats: subcat.categories.pluck(:id).join(',') } }
  end

  private
    def current_user_company
      @company = current_user.company
      @projects = current_user.projects.sort_by_newest.includes(:step1, :step2, :step3, :step4).paginate(page: params[:page], per_page: 4)
      @bids = current_user.bids.paginate(page: params[:page], per_page: 4)

      respond_to do |format|
        format.html
        format.js { render partial: 'shared/project', collection: @projects }
      end
    end
end
