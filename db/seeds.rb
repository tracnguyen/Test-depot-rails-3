# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

Admin.create! \
	:email => "admin@hiringapp.com",
	:password => "asdf7890"

DefaultJobStage.create! :name => "New", :color => "#ffff99"
DefaultJobStage.create! :name => "Screened", :color => "#339966"
DefaultJobStage.create! :name => "Interviewed", :color => "#00ccff"
DefaultJobStage.create! :name => "Offered", :color => "#3366ff"
DefaultJobStage.create! :name => "Hired", :color => "#800000"
DefaultJobStage.create! :name => "Rejected", :color => "#ff0000"


DefaultMessageTemplate.create! \
  :subject => "re: your application to the {{job}} position at {{company}}",
  :body => <<-EOS
Dear {{applicant}},



Regards,

HR Department
{{company}}
EOS


DefaultMessageTemplate.create! \
  :subject => "Interview for a {{job}} position",
  :body => <<-EOS
Dear {{applicant}},

We are impressed by your application. We would like to schedule an interview with you in the coming week. What day would be best for you?

Regards,

HR Department
{{company}}
EOS
