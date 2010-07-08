ENV['RAILS_ENV'] ||= 'development'
require File.dirname(__FILE__) + '/../config/environment'
require 'net/pop'
require 'net/imap'
require 'net/http'
require 'rubygems'
require 'logger'
require "yaml"
require "pp"

module MailFetcher  
  class Pop3Fetcher
    def self.fetch(config={})
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
            MailReceiver.receive(m.pop)
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
    def self.fetch(config={})
      log = Logger.new(STDOUT)
      begin
        imap = Net::IMAP.new(config[:server], config[:port], config[:ssl])
        imap.login(config[:username], config[:password])
        log.info "logged in"
      
        imap.select('Inbox')
        new_emails = imap.uid_search(["NOT", "SEEN"])
        log.info "Found #{new_emails.size} new email in the server"
        new_emails.each do |uid|
          source   = imap.uid_fetch(uid, 'RFC822').first.attr['RFC822']
          MailReceiver.receive(source)
        end
      
        imap.logout
        imap.disconnect
      
        # NoResponseError and ByResponseError happen often when imap'ing
        rescue Net::IMAP::NoResponseError => e
          # Log if you'd like
        rescue Net::IMAP::ByeResponseError => e
          # Log if you'd like
        rescue => e
          log.warn e
      end      
    end
  end
end

# TODO: replace this configuration for each account
gmail_pop_config = {
  :server => "pop.gmail.com",
  :port => 995,
  :ssl => true,
  :username => "hoang.nghiem@techpropulsionlabs.com",
  :password => "hnghiem1!"
}

gmail_imap_config = {
  :server => "imap.gmail.com",
  :port => 993,
  :ssl => true,
  :username => "hoang.nghiem@techpropulsionlabs.com",
  :password => "hnghiem1!"
}
settings = EmailSetting.all
settings.each do |setting|
  config = {
    :server => setting.server,
    :port => setting.port,
    :ssl => setting.ssl,
    :username => setting.username,
    :password => setting.password
  }
  if setting.protocol == "POP3"
    MailFetcher::Pop3Fetcher.fetch(config)
  else
    MailFetcher::ImapFetcher.fetch(config)
  end
end
