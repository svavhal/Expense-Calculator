class Payer < ActiveRecord::Base
  # Associations
  belongs_to :group
  belongs_to :user

  before_save :set_amount

  def set_amount
    amt = status ? (amount || 0 ): 0
    self.amount = amt
  end
end
