require 'config/boot'
require 'config/environment'

handler do |job|
  puts "Running #{job} ..."
end

every(1.minutes, 'mail.polling') { Delayed::Job.enqueue MailPollingJob.new }
