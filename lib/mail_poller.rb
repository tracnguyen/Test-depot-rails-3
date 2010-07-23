require 'net/pop'
require 'net/imap'
require 'net/http'
require 'rubygems'
require 'logger'
require 'yaml'
require 'pp'

module MailPoller
  class Pop3Fetcher
    def self.fetch(receiver, config)
      log = Logger.new(STDOUT)
      Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE) if config[:ssl]
      Net::POP3.start(config[:server], 
                config[:port], 
                config[:username], 
                config[:password]) do |pop|
      
        log.info "Logged in #{config[:server]}"
        unless pop.mails.empty?
          puts "Number of mails #{pop.n_mails}" 
          pop.each_mail do |m|
            receiver.constantize.receive(m.pop)
          end
        else
          log.info "No mail"
        end
        pop.finish
      end
      log.info "Completed"
    end
  end
  
  class ImapFetcher
    def self.fetch(receiver, config)
      log = Logger.new(STDOUT)
      begin
        imap = Net::IMAP.new(config[:server], config[:port], config[:ssl])
        imap.login(config[:username], config[:password])
        log.info "logged in #{config[:username]}"
      
        imap.select('Inbox')
        new_emails = imap.uid_search(["NOT", "SEEN"])
        log.info "Found #{new_emails.size} new email in the server."
        new_emails.each do |uid|
          source = imap.uid_fetch(uid, 'RFC822').first.attr['RFC822']
          receiver.constantize.receive(source)
        end
      
        imap.logout
        imap.disconnect
      
        # NoResponseError and ByResponseError happen often when imap'ing
        rescue Net::IMAP::NoResponseError => e
          log.warn "Authenticate failed!"
        rescue Net::IMAP::ByeResponseError => e
          log.warn e
        rescue => e
          log.warn e
      end      
    end
  end
end
