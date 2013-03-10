class AddDropboxUrlToImages < ActiveRecord::Migration
  def change
    add_column :images, :dropbox_url, :text
  end
end
