class RenameHashToHashChecksumOnImages < ActiveRecord::Migration
  def change
    rename_column :images, :hash, :hash_checksum
  end
end
