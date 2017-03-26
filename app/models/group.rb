class Group < ActiveRecord::Base
  has_many :members
  has_many :users, through: :members
  has_many :bills, dependent: :destroy
  has_many :payers, dependent: :destroy
  accepts_nested_attributes_for :members, reject_if: :all_blank

  validates :name, presence: true, uniqueness: true

  def settle_up_bill
    payer_details = bills.map(&:payers).flatten.group_by(&:user_id)
    settle_up_bill_details = payer_details.each_with_object({}) do |(user_id, payer_details), obj|
      obj[user_id] = payer_details.map(&:amt_borrowed).sum(:+)
    end
  end

  def settlement_info(_user_id)
    current_user = User.find _user_id
    h = settle_up_bill
    amount = h[_user_id]
    messages = []
    h.each do |k, v|
      next if k === _user_id
      break if amount == 0
      bill_user = User.find k
      if amount < 0
        if v > 0
          amount += v
          if amount > 0
            messages.push "#{current_user.name} Owes #{bill_user.name} $#{(h[_user_id] * -1).round(2)}"
            h[_user_id] = 0
            h[k] = amount
            amount = 0
          else
            h[k] = 0
            h[_user_id] = amount
            messages.push "#{current_user.name} Owes #{bill_user.name} $#{v.round(2)}"
          end
        end
      else
        if v < 0
          amount += v
          if amount < 0
            h[_user_id] = 0
            h[k] = amount
            messages.push "#{current_user.name} borrows #{bill_user.name} $#{(amount * -1).round(2)} "
            amount = 0
          else
            h[k] = 0
            h[_user_id] = amount
            messages.push "#{current_user.name} borrows #{bill_user.name} $#{(v * -1).round(2)} "
          end
        end
      end
    end
    messages
  end
end
