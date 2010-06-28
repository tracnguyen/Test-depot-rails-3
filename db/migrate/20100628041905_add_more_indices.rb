class AddMoreIndices < ActiveRecord::Migration
  def self.up
    add_index :accounts, [:subdomain], :name => "index_accounts_on_subdomain", :unique => true
    add_index :jobs, [:account_id], :name => "index_jobs_on_account"
    add_index :job_stages, [:account_id], :name => "index_job_stages_on_account"
    
    add_index :activities, [:applicant_id], :name => "index_activities_on_applicant"
    add_index :activities, [:account_id], :name => "index_activities_on_account"
  end

  def self.down
  end
end
