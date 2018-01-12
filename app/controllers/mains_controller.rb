class MainsController < ApplicationController
  layout :main_layout
  before_action :data_filter, only: [:index, :filter_companies]

  def index
    if user_signed_in?
      if params[:subcats]
        @selected_subcats = params[:subcats].split(',')
      end

      @subcats_services = Subcategory.where(type_id: 3).collect { |subcat| { id: subcat.id, name: subcat.name, cats: subcat.categories.pluck(:id).join(',') } }
      @subcats_agencies = Subcategory.where(type_id: 4).collect { |subcat| { id: subcat.id, name: subcat.name, cats: subcat.categories.pluck(:id).join(',') } }
      @subcats_type     = Subcategory.where(type_id: 5).collect { |subcat| { id: subcat.id, name: subcat.name, cats: subcat.categories.pluck(:id).join(',') } }
      @subcats_products = Subcategory.where(type_id: 1).collect { |subcat| { id: subcat.id, name: subcat.name, cats: subcat.categories.pluck(:id).join(',') } }
      @subcats_fabrics  = Subcategory.where(type_id: 2).collect { |subcat| { id: subcat.id, name: subcat.name, cats: subcat.categories.pluck(:id).join(',') } }
    else
      render :landing
    end
  end

  def filter_companies
    html = render_to_string partial: '/shared/companies', locals: { companies: @companies }
    render json: { all: @all, count: @count, html: html }
  end

  def get_hints
    html = ''
    if params[:text].present?
      @companies = Company.availables.search_by_name(params[:text])
      html = render_to_string partial: '/shared/hints', locals: { companies: @companies }
    end
    render json: { html: html }
  end
  
  def check_address
    if params[:ajax] == '1' && params[:address].present?
      address = params[:address]
      company = Company.find_by(address: address)

      respond_to do |format|
        if company.present? 
          format.html { render text: 'that address is already registered', status: :unprocessable_entity }
        else
          format.html { render text: 'ok', status: :ok }
        end
      end
    end
  end

  def register_end
    render layout: 'application'
  end

  private
    def main_layout
       'main' unless user_signed_in?
    end

    def data_filter  
      @max = Ctrl.find_by_nm('search_companies').val

      params[:limit] = @max unless params[:limit].present?
      params[:offset] = 0 unless params[:offset].present?

      @companies = Company.availables

      if params[:subcats].present?
        data = params[:subcats].split(',')
        csc_ids = CompaniesSubcategoriesConnection.where(subcategory_id: data).pluck(:company_id).uniq
        @companies = @companies.where(id: csc_ids)
      end

      @companies = @companies.order_by_date if params[:order] == 'date'
      @companies = @companies.order_by_name if params[:order] == 'name'
      @companies = @companies.search_by_name(params[:text]) if params[:text].present?
      @companies = @companies.order_by_state(params[:state]) if params[:state].present?
      @all = @companies.count - params[:offset].to_i
      @companies = @companies.limit("#{params[:limit].to_i}").offset(params[:offset])
      @count = @companies.count

      return @companies, @all, @count, @max
    end
end
