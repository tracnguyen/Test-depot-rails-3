# == Schema Information
#
# Table name: accounts
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  subdomain   :string(255)
#  owner_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Account < ActiveRecord::Base
  has_many :users
  has_many :jobs
  has_many :job_stages
  has_many :applicants
  has_many :activities
  has_many :messages, :order => "created_at DESC"
  has_many :message_templates
  has_one :email_setting, :as => :configurable
  
  validates_presence_of :name, :subdomain
  validates_uniqueness_of :subdomain
  
  belongs_to :owner, :class_name => "User"
  accepts_nested_attributes_for :owner, :email_setting
  
  after_create lambda {
    DefaultJobStage.all.each_with_index { |s, i|
      JobStage.create! \
        :account_id => self.id,
        :name => s.name,
        :position => i,
        :color => s.color
    }
    
    DefaultMessageTemplate.all.each { |t|
      MessageTemplate.create! :account_id => self.id, :subject => t.subject, :body => t.body
    }
  }
    
  def self.find_by_owner_email(email)
    sql = "SELECT accounts.id FROM accounts "
    sql << "INNER JOIN users ON accounts.owner_id = users.id "
    sql << "WHERE users.email = '#{email}'"
    accounts = Account.find_by_sql(sql)
    !accounts.blank? ? accounts.first : nil    
  end
end


