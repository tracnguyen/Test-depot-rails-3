class ConversationPollingJob
  def perform
    settings = EmailSetting.where(:configurable_type => "Job")
    settings.each do |setting|
      config = {
        :server => setting.server,
        :port => setting.port,
        :ssl => setting.ssl,
        :username => setting.username,
        :password => setting.password
      }
      if setting.protocol == "POP3"
        MailPoller::Pop3Fetcher.fetch("ConversationReceiver", config)
      else
        MailPoller::ImapFetcher.fetch("ConversationReceiver", config)
      end
    end
  end
end

