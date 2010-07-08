class AddCoverLetterToApplicants < ActiveRecord::Migration
  def self.up
    add_column :applicants, :resume, :text
    rename_column :applicants, :cv, :cover_letter
  end

  def self.down
    remove_column :applicants, :resume
    rename_column :applicants, :cover_letter, :cv
  end
end
