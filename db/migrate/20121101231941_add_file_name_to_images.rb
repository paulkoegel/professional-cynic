class AddFileNameToImages < ActiveRecord::Migration
  def change
    add_column :images, :file_name, :string
  end
end
