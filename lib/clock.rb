require 'config/boot'
require 'config/environment'

handler do |job|
  puts "Running #{job} ..."
end

every(5.minutes, 'mail.polling') { Delayed::Job.enqueue MailPollingJob.new }
every(5.minutes, 'conversation.polling') { Delayed::Job.enqueue ConversationPollingJob.new }
