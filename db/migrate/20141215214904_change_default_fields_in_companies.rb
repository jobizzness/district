class ChangeDefaultFieldsInCompanies < ActiveRecord::Migration
  def change
    change_column :companies, :address2, :string, :default => ''

    change_column :companies, :zip, :string, :limit => 20, :default => ''
    change_column :companies, :city, :string,  :default => ''
    change_column :companies, :state, :string,  :default => ''    
    change_column :companies, :country, :string, :limit => 4, :default => ''        
    change_column :companies, :phone, :string, :default => ''        
    change_column :companies, :email, :string, :default => ''        
    change_column :companies, :website, :string, :default => ''        
    change_column :companies, :twitter, :string, :default => ''            
    change_column :companies, :facebook, :string, :default => ''                
    change_column :companies, :instagram, :string, :default => ''                    
    change_column :companies, :pinterest, :string, :default => ''                        
    change_column :companies, :description, :text
    change_column :companies, :avatar_old, :string, :default => ''                        
    change_column :companies, :logo_old, :string, :default => ''                            
    change_column :companies, :x, :string, :default => ''                            
    change_column :companies, :y, :string, :default => ''                            
    change_column :companies, :zoom, :integer, :default => 0
    change_column :companies, :fb_reposts, :integer, :default => 0
    change_column :companies, :tw_reposts, :integer, :default => 0
    change_column :companies, :gp_reposts, :integer, :default => 0
    change_column :companies, :in_reposts, :integer, :default => 0
    
    change_column :companies, :search, :text
    change_column :companies, :available, :string, :default => '0000'                        
    change_column :companies, :cats, :string, :default => ''                        
    change_column :companies, :brief, :string, :default => ''                        
    
  end
end
