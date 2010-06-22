class CreateDefaultJobStages < ActiveRecord::Migration
  def self.up
    create_table :default_job_stages do |t|
      t.string :name

      t.timestamps
    end
    
    DefaultJobStage.create :name => "New"
    DefaultJobStage.create :name => "Interview"
    DefaultJobStage.create :name => "Test"
  end

  def self.down
    drop_table :default_job_stages
  end
end
