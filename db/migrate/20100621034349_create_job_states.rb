class CreateJobStates < ActiveRecord::Migration
  def self.up
    create_table :job_states do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
    
    JobState.create :name => "Apply"
    JobState.create :name => "Test"
    JobState.create :name => "Interview"
  end

  def self.down
    drop_table :job_states
  end
end
