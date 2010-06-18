class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.integer :account_id
      t.string :title
      t.text :description
      t.string :status
      t.date :creation_date
      t.date :expiry_date
    end
  end

  def self.down
    drop_table :jobs
  end
end
