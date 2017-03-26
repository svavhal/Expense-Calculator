class Group < ActiveRecord::Base
  # Associtaions
  has_many :members
  has_many :users, through: :members
  has_many :bills, dependent: :destroy
  has_many :payers, dependent: :destroy
  accepts_nested_attributes_for :members, reject_if: :all_blank

  # Validations
  validates :name, presence: true, uniqueness: true

  def settle_up_bill
    payer_details = bills.map(&:payers).flatten.group_by(&:user_id)
    settle_up_bill_details = payer_details.each_with_object({}) do |(user_id, payer_details), obj|
      obj[user_id] = payer_details.map(&:amt_borrowed).sum(:+)
    end
  end

  def settlement_info(_user_id)
    settlemet_info = SettlementInfo.new(settle_up_bill, _user_id)
    settlemet_info.settleup_messages
  end
end
