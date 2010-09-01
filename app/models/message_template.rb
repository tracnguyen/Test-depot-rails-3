class MessageTemplate < ActiveRecord::Base
  belongs_to :account
  validates_presence_of :subject, :body
  
  HELP = %(<div class=help>
  	<p>The following substitutions are possible:</p>
  	<ul>
  		<li><strong>{{applicant}}</strong> is the applicant's full name</li>
  		<li><strong>{{job}}</strong> is the job title</li>
  		<li><strong>{{company}}</strong> is the company's name</li>
  	</ul>
  </div>)

  def render_for(applicant)
    vals = {
      'applicant' => applicant.display_name,
      'company' => applicant.account.name,
      'job' => applicant.job.title
    }
    {
      :subject => Liquid::Template.parse(self.subject).render(vals),
      :body => Liquid::Template.parse(self.body).render(vals)
    }
  end
  

end

# == Schema Information
#
# Table name: message_templates
#
#  id         :integer         not null, primary key
#  subject    :string(255)
#  body       :text
#  account_id :integer
#  created_at :datetime
#  updated_at :datetime
#

