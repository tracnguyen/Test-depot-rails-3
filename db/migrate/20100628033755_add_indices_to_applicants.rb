class AddIndicesToApplicants < ActiveRecord::Migration
  def self.up
    add_index :applicants, [:account_id, :job_stage_id], :name => "index_applicants_on_account_and_stage"
    add_index :applicants, [:job_id, :job_stage_id], :name => "index_applicants_on_job_and_stage"
  end

  def self.down
  end
end
