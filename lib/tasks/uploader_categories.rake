namespace :db do
  desc 'uploader images for Categories'
  task uploader_images_of_categories: :environment do
    files = Dir["#{Rails.root}/old_images/categories/*.*"]
    for file in files
      file_name = file.split('/')[-1]
      category = Category.find_by(pic_old: file_name)
      category.update(pic: File.open(file, 'rb')) if category
    end
  end
end
