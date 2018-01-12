# encoding: UTF-8
# rake task for create / drop Users - manager
#require 'faker'

namespace :db do
  desc 'populate db by User - manager'
  task populate_db_user_manager: :environment do

    (1..2).each do |data|
      unless Manager.find_by_email("manager#{data}@dstrct2.co")
        manager = Manager.new(
          email:                 "manager#{data}@dstrct2.co",
          password:              '12345678',
          password_confirmation: '12345678',
        )
        if manager.save
          puts "---> added manager #{manager.email}"
        end
      end
      sleep 2
    end
  end

  desc 'truncate User - maanager'
  task truncate_db_user_manager: :environment do
    Manager.all.delete_all
    puts '---> delete data from Manager'
  end
end

