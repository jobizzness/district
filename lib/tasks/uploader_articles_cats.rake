namespace :db do
  desc 'uploader images for ArticlesCat'
  task uploader_images_of_articles_cats: :environment do
    files = Dir["#{Rails.root}/old_images/articles_cats/big/*.*"]
    for file in files
      file_name = file.split('/')[-1]
      article_cat = ArticlesCat.find_by(pic_old: file_name)
      article_cat.update(pic: File.open(file, 'rb')) if article_cat
    end
  end
end
