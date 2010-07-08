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
  
  def mark_as_read(applicant)
    uv = self.user_views.where('applicant_id' => applicant.id)
    if uv.empty?
      self.user_views.create(:applicant_id => applicant.id)
    end
    applicant.update_attribute(:is_read, true) unless applicant.is_read
  end
  
  def mark_as_unread(applicant)
    self.user_views.where('applicant_id' => applicant.id).delete_all
    applicant.update_attribute(:is_read, false) if applicant.is_read
  end

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
end
