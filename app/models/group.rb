class Group < ActiveRecord::Base
  has_many :members
  has_many :users, through: :members
  has_many :bills, dependent: :destroy
  has_many :payers, dependent: :destroy
  accepts_nested_attributes_for :members, reject_if: :all_blank

  validates :name, presence: true, uniqueness: true

  def settle_up_bill
  	payer_details = bills.map(&:payers).flatten.group_by { |payer| payer.user_id }
  	settle_up_bill_details = payer_details.each_with_object({}) { |(user_id, payer_details), obj|
  		obj[user_id] = payer_details.map(&:amt_borrowed).sum(:+)
  	}
  end

  
end
