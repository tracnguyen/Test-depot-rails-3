class AddContentTypeToApplicant < ActiveRecord::Migration
  def self.up
    add_column :applicants, :cover_letter_content_type, :string, :default => 'text'
    add_column :applicants, :resume_content_type, :string
  end

  def self.down
    remove_column :applicants, :resume_content_type, :string,  :default => 'text'
    remove_column :applicants, :cover_letter_content_type
  end
end
