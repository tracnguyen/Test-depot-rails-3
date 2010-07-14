require 'rubygems'
require 'nokogiri'

module EmailExtractor
  
  def self.parse(html)
    Nokogiri::HTML(html)
  end

  class VietnamWorks
    MAIL_SERVER = "navigosgroup.com"
    
    def self.extract_phone(html)
      doc = EmailExtractor.parse(html)
      phone_num = doc.xpath("//table[2]/tbody/tr/td/div/table/tbody/tr[6]/td[2]") \
                     .collect(&:text).first.gsub(/[\t\n\r\f\s]/, '')
      # format phone number if necessary
      if !phone_num.nil?
        phone_num = phone_num.split("/").uniq.join(" / ") if phone_num.include?("/")
      end      
      phone_num || ""
    end
    
    def self.extract_position(html)
      doc = EmailExtractor.parse(html)
      position = doc.xpath("//table[3]//table/tbody/tr/td[2]").collect(&:text).first.strip
    end
  end
  
end
