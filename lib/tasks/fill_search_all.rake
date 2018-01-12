namespace :db do
  desc 'populate column Search All for companies'
  task populate_column_search_all: :environment do

    Company.all.each do |company|
      search = [
        company.name,
        company.address,
        company.search,
        company.subcategories.pluck(:name).join(','),
        company.country, company.address1, company.address2, company.city, company.zip,
        company.phone, company.email, company.website,
        company.twitter, company.facebook, company.instagram, company.pinterest,
        company.brief, company.description
      ].compact.join(',')

      if company.update search_all: search
        puts "---> filled data for company '#{company.name}'"
      end
    end
  end
end

