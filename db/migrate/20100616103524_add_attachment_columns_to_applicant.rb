class AddAttachmentColumnsToApplicant < ActiveRecord::Migration
  def self.up
    add_column :applicants, :attachment_file_name,    :string
    add_column :applicants, :attachment_content_type, :string
    add_column :applicants, :attachment_file_size,    :integer
    add_column :applicants, :attachment_updated_at,   :datetime
  end

  def self.down
    remove_column :applicants, :attachment_file_name
    remove_column :applicants, :attachment_content_type
    remove_column :applicants, :attachment_file_size
    remove_column :applicants, :attachment_updated_at
  end
end
