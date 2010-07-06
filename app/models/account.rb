class Account < ActiveRecord::Base
  has_many :users
  has_many :jobs
  has_many :job_stages
  has_many :applicants
  has_many :activities
  
  validates_presence_of :name, :subdomain
  validates_uniqueness_of :subdomain
  
  belongs_to :owner, :class_name => "User"
  accepts_nested_attributes_for :owner
  
  after_create lambda {
    DefaultJobStage.all.each_with_index { |s, i|
      JobStage.create \
      	:account_id => self.id,
      	:name => s.name,
      	:position => i,
      	:color => s.color
      }
    }
end

