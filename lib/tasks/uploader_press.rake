namespace :db do
  desc 'uploader images for Press'
  task uploader_images_of_press: :environment do
    files = Dir["#{Rails.root}/old_images/press/big/*.*"]
    for file in files
      file_name = file.split('/')[-1]
      press = Press.find_by(pic_old: file_name)
      press.update(pic: File.open(file, 'rb')) if press
    end
  end
end
