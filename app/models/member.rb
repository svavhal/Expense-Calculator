class Member < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :group

  def user_id=(user_id)
    uid = set_user_id user_id
    write_attribute(:user_id, uid)
  end

  def set_user_id(email)
    user = User.find_by email: email
    user.id if user.present?
  end
end
