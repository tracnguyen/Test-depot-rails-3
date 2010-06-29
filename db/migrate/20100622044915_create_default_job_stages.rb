class CreateDefaultJobStages < ActiveRecord::Migration
  def self.up
    create_table :default_job_stages do |t|
      t.string :name
      t.string :color

      t.timestamps
    end
  end

  def self.down
    drop_table :default_job_stages
  end
end
