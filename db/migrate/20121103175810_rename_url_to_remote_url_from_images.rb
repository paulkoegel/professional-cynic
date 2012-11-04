class RenameUrlToRemoteUrlFromImages < ActiveRecord::Migration
  def change
    rename_column :images, :url, :remote_url
  end
end
