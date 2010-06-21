class CreateUserViews < ActiveRecord::Migration
  def self.up
    create_table :user_views, :id => false do |t|
      t.integer :user_id
      t.integer :applicant_id
    end
  end

  def self.down
    drop_table :user_views
  end
end
