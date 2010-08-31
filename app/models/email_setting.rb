# == Schema Information
#
# Table name: email_settings
#
#  id                :integer         not null, primary key
#  server            :string(255)
#  port              :string(255)
#  username          :string(255)
#  password          :string(255)
#  ssl               :boolean         default(TRUE)
#  protocol          :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  configurable_id   :integer
#  configurable_type :string(255)
#

require 'aes_crypt'

class EmailSetting < ActiveRecord::Base
#  belongs_to :account
  belongs_to :configurable, :polymorphic => true
  #validates_presence_of :server, :port, :protocol, :username, :password
  #validate :validate_setting
  after_find :decrypt_password
  before_save :encrypt_password
  
  def decrypt_password
    if !self.password.blank?
      self.password = AesCrypt.decrypt(self.password, 
                                       Rails.application.config.secret_token, 
                                       nil, 
                                       "AES-256-ECB")
    end
  end
  
  def encrypt_password
    if !self.password.blank?
      self.password = AesCrypt.encrypt(self.password, 
                                       Rails.application.config.secret_token, 
                                       nil, 
                                       "AES-256-ECB")
    end
  end
  
  def validate_setting
    if self.protocol == "IMAP"
      errors.add(:server, "Cannot connect to mail server with this setting.") if !imap_valid?
    elsif self.protocol == "POP3"
      errors.add(:server, "Cannot connect to mail server with this setting.") if !pop3_valid?
    end
  end
  
  def pop3_valid?
    require 'rubygems'
    require 'net/pop'
    require 'net/http'

    valid = false
    begin
      Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE) if self.ssl
      Net::POP3.start(self.server, self.port, self.username, self.password) do |pop|
        valid = true            
      end
    rescue
      valid = false
    end
    valid
  end
  
  def imap_valid?
    require 'rubygems'
    require 'net/imap'
    require 'net/http'
    
    valid = false
    begin
      imap = Net::IMAP.new(self.server, self.port, self.ssl)
      imap.login(self.username, self.password)
      valid = true
    rescue
      valid = false
    end
    valid
  end
end

