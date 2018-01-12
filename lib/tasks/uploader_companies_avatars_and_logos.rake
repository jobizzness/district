namespace :db do
  desc 'uploader images for Company - avatars and logos'
  task uploader_companies_avatars_and_logos: :environment do

    avatar_files = Dir["#{Rails.root}/old_images/companies/avatars/big/*.*"]
    for file in avatar_files
      file_name = file.split('/')[-1]
      company_avatar = Company.find_by(avatar_old: file_name)
      company_avatar.update(avatar: File.open(file, 'rb')) if company_avatar
    end

    logos_files = Dir["#{Rails.root}/old_images/companies/logos/big/*.*"]
    for file in logos_files
      file_name = file.split('/')[-1]
      company_logo = Company.find_by(logo_old: file_name)
      company_logo.update(logo: File.open(file, 'rb')) if company_logo
    end
  end
end
