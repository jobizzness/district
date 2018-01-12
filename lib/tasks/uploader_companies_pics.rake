namespace :db do
  desc 'uploader images for CompaniesPics'
  task uploader_companies_pics: :environment do

    files = Dir["#{Rails.root}/old_images/companies/pics/big/*.*"]
    for file in files
      file_name = file.split('/')[-1]
      company_pic = CompaniesPic.find_by(pic_old: file_name)
      company_pic.update(pic: File.open(file, 'rb')) if company_pic
    end
  end
end
