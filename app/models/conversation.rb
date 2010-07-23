class Conversation < ActiveRecord::Base
  belongs_to :applicant
  
  DELIMITER = "--- REPLY ABOVE THIS LINE to give your reply ---"
  attr_accessor :attachment
end
