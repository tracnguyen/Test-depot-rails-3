class CreateDefaultJobStages < ActiveRecord::Migration
  def self.up
    create_table :default_job_stages do |t|
      t.string :name
      t.string :color

      t.timestamps
    end
    
    DefaultJobStage.create :name => "New", :color => "#3366ff"
    DefaultJobStage.create :name => "Interview", :color => "#993300"
    DefaultJobStage.create :name => "Screened", :color => "#339966"
    DefaultJobStage.create :name => "Hired", :color => "#33cccc"
    DefaultJobStage.create :name => "Offered", :color => "#ff99cc"
    DefaultJobStage.create :name => "Rejected", :color => "#999999"
  end

  def self.down
    drop_table :default_job_stages
  end
end
