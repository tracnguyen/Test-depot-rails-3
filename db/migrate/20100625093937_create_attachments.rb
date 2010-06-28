class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.string :caption
      t.integer :attachable_id
      t.string :attachable_type
      
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
