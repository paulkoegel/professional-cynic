class CreateGalleryships < ActiveRecord::Migration
  def change
    create_table :galleryships do |t|
      t.belongs_to :gallery
      t.belongs_to :image
      t.boolean :is_active

      t.timestamps
    end
  end
end
