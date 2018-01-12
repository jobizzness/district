class CreateTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_members do |t|
      t.string :name
      t.text :about
      t.string :post
      t.string :link_fb
      t.string :link_li
      t.string :link_tw
      t.string :link_in

      t.timestamps
    end
  end
end
