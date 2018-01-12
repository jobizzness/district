namespace :db do
  desc 'uploader images for ArticlesPic'
  task uploader_images_of_articles_pics: :environment do
    files = Dir["#{Rails.root}/old_images/articles/big/*.*"]
    for file in files
      file_name = file.split('/')[-1]
      article_pic = ArticlesPic.find_by(path_old: file_name)
      article_pic.update(path: File.open(file, 'rb')) if article_pic
    end
  end
end
