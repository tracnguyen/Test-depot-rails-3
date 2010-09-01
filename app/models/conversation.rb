class Conversation < ActiveRecord::Base
  belongs_to :applicant
  
  DELIMITER = "--- REPLY ABOVE THIS LINE to give your reply ---"
  attr_accessor :attachment
  
  before_save :render_message
  
  def render_message
    self.subject = Liquid::Template.parse(self.subject).render(template_vals)
    self.body = Liquid::Template.parse(self.body).render(template_vals)
  end
  
protected
  
  def template_vals
    {
      'applicant' => self.applicant.display_name,
      'company' => self.applicant.account.name,
      'job' => self.applicant.job.title
    }
  end
end



# == Schema Information
#
# Table name: conversations
#
#  id           :integer         not null, primary key
#  content_type :string(255)
#  message      :text
#  outgoing     :boolean
#  applicant_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#  subject      :string(255)
#

