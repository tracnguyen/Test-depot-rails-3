# == Schema Information
#
# Table name: user_views
#
#  user_id      :integer
#  applicant_id :integer
#

class UserView < ActiveRecord::Base
  belongs_to :user
  belongs_to :applicant
  
  def self.mark_as_read(user, applicant)
    uv = user.user_views.where('applicant_id' => applicant.id)
    if uv.blank?
      user.user_views.create(:applicant_id => applicant.id)
    end
  end
  
  def self.mark_as_unread(user, applicant)
    user.user_views.where('applicant_id' => applicant.id).delete_all
  end
end

