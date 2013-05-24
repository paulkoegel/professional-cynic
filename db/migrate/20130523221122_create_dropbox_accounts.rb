class CreateDropboxAccounts < ActiveRecord::Migration
  def change
    create_table :dropbox_accounts do |t|
      t.string :request_secret
      t.string :request_token

      t.timestamps
    end
  end
end
