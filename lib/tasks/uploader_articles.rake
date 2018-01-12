namespace :db do
  desc 'uploader images for Article'
  task uploader_images_of_article: :environment do
    files = Dir["#{Rails.root}/old_images/articles/big/*.*"]
    for file in files
      file_name = file.split('/')[-1]
      article = Article.find_by(pic_old: file_name)
      article.update(pic: File.open(file, 'rb')) if article
    end
  end
end
