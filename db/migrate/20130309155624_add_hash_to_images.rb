class AddHashToImages < ActiveRecord::Migration
  def change
    add_column :images, :hash, :text
  end
end
