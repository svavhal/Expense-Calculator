class Group < ActiveRecord::Base
  has_many :members
  has_many :users, through: :members
  has_many :bills, dependent: :destroy
  has_many :payers, dependent: :destroy
  accepts_nested_attributes_for :members, reject_if: :all_blank

  def settle_up_bill
  	payer_details = bills.map(&:payers).flatten.group_by { |payer| payer.user_id }
  	settle_up_bill_details = payer_details.each_with_object({}) { |(user_id, payer_details), obj|
  		obj[payer_details.first.user.name] = payer_details.map(&:amt_borrowed).sum(:+)
  	}

  	settle_up_bill_details.each do |k, v|
  		temp = []
  		settle_up_bill_details.each do |m, n|
  			next if k == m
  			if v < 0 && n > 0 && v >= n
  				temp.push "#{m} owes you $#{n}"
  			else
  				temp.push "#{m} borrow you $#{n}"
  			end
  		end
  	end
  end
end
