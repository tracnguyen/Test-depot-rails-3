# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

Admin.create! \
	:email => "admin@hiringapp.com",
	:password => "asdf7890"

DefaultJobStage.create :name => "New", :color => "#ffff99"
DefaultJobStage.create :name => "Screened", :color => "#339966"
DefaultJobStage.create :name => "Interviewed", :color => "#00ccff"
DefaultJobStage.create :name => "Offered", :color => "#3366ff"
DefaultJobStage.create :name => "Hired", :color => "#800000"
DefaultJobStage.create :name => "Rejected", :color => "#ff0000"
