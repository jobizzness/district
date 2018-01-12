namespace :db do
  desc 'updater models '
  task updater_models: :environment do

    Article.all.each do |data|
      data.update(created_at: data.date, updated_at: data.date)
    end
    puts "---> updated data in model Article"

    Company.all.each do |data|
      data.update(created_at: data.date, updated_at: data.date)
    end
    puts "---> updated data in model Company"

  end
end
