class User < ActiveRecord::Base
  devise \
    :database_authenticatable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable
  
  devise :lockable,
    :lock_strategy => :failed_attempts,
    :maximum_attempts => 5,
    :unlock_strategy => :email
  
  attr_accessible :email, :password, :password_confirmation
  
  belongs_to :account
  
  def owns?(account)
    account.owner == self
  end
  
  has_many :user_views
  has_many :viewed_applications, :through =>  :user_views, :class_name => "Applicant", :source => "applicant"
  has_many :message_readings
  has_many :messages, :through => :message_readings, :order => 'created_at DESC'

  # Return this user's read status of the list of applicants as a hash of
  # { applicant_id => true } for those applications that the user has viewed.
  def read_status(applicants)
    viewstat = {}
    app_ids = applicants.map { |app| app.id }
    viewed = self.user_views.where('applicant_id' => app_ids).joins(:applicant)
    viewed.each do |uv|
    	viewstat[uv.applicant_id] = true
    end
    viewstat
  end
  
  has_many :invitations, :foreign_key => "inviter_id"
  
  def unread_messages_count
    self.message_readings.unread.count
  end
  
  def unread?(message)
    ids = MessageReading.select("message_id") \
                        .where(:user_id => id, :is_read => false) \
                        .map {|mr| mr.message_id}
    ids.include?(message.id) 
  end
  
  def all_messages(page, per_page)
    messages.paginate(:page => page, :per_page => per_page).each do |m|
      m.is_read = !unread?(m)
    end
  end
end
