require 'csv'

class Admins::CompaniesController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @companies = Company.order(id: :desc).includes :users
  end

  def export
    companies = if params[:companies_ids].present?
      Company.where(id: params[:companies_ids]).includes :users
    else
      Company.includes :users
    end

    results = CSV.generate do |csv|
      csv << ['Company name', 'Contact name', 'Company email', 'Contact email', 'Website','Phone']
        
      companies.each do |company|
        data = [company.name, company.user && company.user.name, company.email, company.user && company.user.email, company.website, company.phone]
        csv << data
      end
    end

    return send_data results, type: 'text/csv; charset=utf-8; header=present', disposition: 'attachment', filename: 'companies.csv'
  end

  def import
    @companies = []

    if params[:csv].present?
      user_emails = User.pluck(:email)
      csv_text = File.read params[:csv].path
      csv = CSV.parse csv_text, headers: true

      csv.each do |row|
        if row['Email'].present?
          user_params = {}
          company_params = {}
          row[:failed] = true
          email = row['Email'].gsub(/\s+/, '').downcase

          unless user_emails.include? email
            password = Devise.friendly_token.first(8)

            user_params[:name] = ''
            user_params[:email] = email
            user_params[:password] = password
            user_params[:password_confirmation] = password

            user = User.new(user_params)
            user.skip_confirmation!

            if user.save
              company_params[:name] = row['Company Name'] if row['Company Name'].present?
              company_params[:email] = email
              company_params[:phone] = row['Phone #'] if row['Phone #'].present?
              company_params[:website] = row['Website'] if row['Website'].present?
              company_params[:class_type] = row['Class'] if row['Class'].present?
              company_params[:address] = Time.now.to_i.to_s[2..9]
              company = Company.create(company_params)
              user.companies << company

              token, enc = Devise.token_generator.generate(user.class, :reset_password_token)
              user.reset_password_token   = enc
              user.reset_password_sent_at = Time.now.utc
              user.save validate: false

              AdminMailer.create_company(user_params, company_params, token).deliver_later(wait: 10.seconds)
            end

            row[:failed] = false
          end

          @companies << row
        end
      end
    end
  end
end
