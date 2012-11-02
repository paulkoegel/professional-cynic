class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :url
      t.integer :width
      t.integer :height
      t.string :title
      t.text :caption
      t.datetime :taken_at

      t.timestamps
    end
  end
end
