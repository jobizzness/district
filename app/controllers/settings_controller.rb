class SettingsController < ApplicationController
  before_action :set_setting, only: [:index, :update, :upload_avatar, :upload_gallery, :delete_pic, :sort_pic, :set_new_coords, :set_new_zoom]
  before_action :authenticate_user!

  def index
    @user = current_user
    @company = @user.companies.first
    @tags = @company.tags.pluck(:name).join(', ')

    subcategories = @company.subcategories.pluck(:id)

    @subcats_services = Subcategory.where(type_id: 3).collect { |subcat| { id: subcat.id, name: subcat.name, cats: subcat.categories.pluck(:id).join(','), in: subcategories.include?(subcat.id) } }
    @subcats_agencies = Subcategory.where(type_id: 4).collect { |subcat| { id: subcat.id, name: subcat.name, cats: subcat.categories.pluck(:id).join(','), in: subcategories.include?(subcat.id) } }
    @subcats_type     = Subcategory.where(type_id: 5).collect { |subcat| { id: subcat.id, name: subcat.name, cats: subcat.categories.pluck(:id).join(','), in: subcategories.include?(subcat.id) } }
    @subcats_products = Subcategory.where(type_id: 1).collect { |subcat| { id: subcat.id, name: subcat.name, cats: subcat.categories.pluck(:id).join(','), in: subcategories.include?(subcat.id) } }
    @subcats_fabrics  = Subcategory.where(type_id: 2).collect { |subcat| { id: subcat.id, name: subcat.name, cats: subcat.categories.pluck(:id).join(','), in: subcategories.include?(subcat.id) } }
  end
  
  def update
    tags = company_params.extract!(:tags)
    categories = company_params.extract!(:all_cats)
    subcategories = company_params.extract!(:subcats)

    params[:country] = '' if params[:country] == 'undefined'

    params.except!(company_params['avatar-file'])
    params.except!(company_params['logo-file'])

    search = [
      search = tags[:tags],
      subcategories[:subcats].split(',').map { |c| Subcategory.find(c.to_i).name }.join(','),
      params[:country], params[:address1], params[:address2], params[:city], params[:zip],
      params[:phone], params[:email], params[:website],
      params[:twitter], params[:facebook], params[:instagram], params[:pinterest],
      params[:brief], params[:description]
    ].join(',')

    if @company.update(company_params.except(:all_cats, :subcats, :tags).merge!(search: tags[:tags], search_all: search))
      if @company.available == '1111'
        render text: 'ok', status: :ok
      else
        render partial: '/shared/availability', locals: { company: @company }, status: :ok
      end
    else
      render nothing: true
    end

    tags = tags[:tags].split(',').map(&:strip)

    @company.tags.each do |tag|
      CompaniesTagsConnection.where(id_company: @company.id, id_tag: tag.id).destroy_all
      tag.update(count: tag.count.to_i - 1)
    end

    tags.first(25).each do |tag|
      t = Tag.where(name: tag).first
      if t.present?
        t.update(count: t.count.to_i + 1)
      else
        t = Tag.create(name: tag)
      end
      CompaniesTagsConnection.create(id_company: @company.id, id_tag: t.id)
    end

    cats = categories[:all_cats].split(',').map(&:to_i)
    if cats.present?
      @company.categories.delete_all
      cats.each do |id|
        @company.categories << Category.find(id)
      end
    end

    subcats = subcategories[:subcats].split(',').map(&:to_i)
    if subcats.present?
      @company.subcategories.delete_all
      subcats.each do |id|
        @company.subcategories << Subcategory.find(id)
      end
    end
  end

  def upload_gallery
    if params['pic-file'].present? 
      if @company.companies_pics.any?
        last_position = @company.companies_pics.order(:position).last.position.to_i
      else 
        last_position = 0
      end

      cp = CompaniesPic.new(id_company: @company.id, pic: params['pic-file'], position: last_position + 1)
      if cp.save
        render text: cp.id, status: :ok
      else
        render text: { messages: 'Bad' }, status: 401
      end
    end
  end

  def delete_pic
    if params[:id].present? && params[:company].present?
      if @company.companies_pics.where(id: params[:id]).first.delete
        render :text => 'ok'
      else
        render :text => 'bad'    
      end
    end
  end

  def sort_pic
    if params[:pic].present?
      index_pic = 1
      params[:pic].each do |pic|
        @company.companies_pics.find(pic).update(position: index_pic)
        index_pic += 1
      end
      render :text => 'ok'
    else
      render :text => 'bad'    
    end
  end

  def upload_avatar
    if params['avatar-file'].present? 
      if @company.update(avatar: params['avatar-file'])
        render :text => 'ok'
      else
        render :text => 'bad'    
      end
    end

    if params['logo-file'].present? 
      if @company.update(logo: params['logo-file'])
        render :text => 'ok'
      else
        render :text => 'bad'    
      end
    end
  end

  def profile_update
    if params[:current_password].present?
      if current_user.valid_password?(params[:current_password]) && current_user.update(profile_params)
        sign_in current_user, bypass: true
        render nothing: true, status: :ok
      else
        render json: { errors: [ elem: 'current_password', 
                                 message: 'current password is not valid' ]
                     }, status: :unprocessable_entity
      end
    elsif current_user.update(profile_params.except!(:password, :password_confirmation))
      render nothing: true, status: :ok
    else
      render json: { errors: [ elem: 'email', 
                               message: 'email is not valid' ]
                   }, status: :unprocessable_entity
    end
  end

  def add_social
    if params[:id].present? && params[:social].present?
      if params[:social] == 'facebook'
        if current_user.update(facebook: params[:id])
          render text: 'ok'
        else
          render text: 'bad'    
        end
      elsif params[:social] == 'linkedin'
        if current_user.update(linkedin: params[:id])
          render text: 'ok'
        else
          render text: 'bad'    
        end
      elsif params[:social] == 'google'
        if current_user.update(google: params[:id])
          render text: 'ok'
        else
          render text: 'bad'
        end
      end
    end
  end

  def set_new_coords
    if @company.update x: params[:x], y: params[:y], zoom: params[:zoom]
      render text: :ok
    else
      render text: :no
    end
  end

  def set_new_zoom
    if @company.update zoom: params[:zoom]
      render text: :ok
    else
      render text: :no
    end
  end

  private
    def set_setting
      @user = current_user
      @company = @user.companies.first
    end

    def company_params
      params.permit(:name, :address, :address1, :address2, :city, 
        :zip, :phone, :email, :website, :twitter, 
        :facebook, :instagram, :pinterest, :brief, :description,
        :cats, :country, :state, 'all_cats', 'subcats',
        'avatar-file', 'logo-file', :tags, :pic => []
      )
    end

    def profile_params
      params.except!(:current_password).permit(:first_name, :last_name, :name, :email, :password, :password_confirmation)
    end
end
