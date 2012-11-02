class CreateGalleries < ActiveRecord::Migration
  def change
    create_table :galleries do |t|
      t.string :slug
      t.string :title
      t.text :description
      t.string :location
      t.date :string

      t.timestamps
    end
  end
end
