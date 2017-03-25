class Bill < ActiveRecord::Base
  belongs_to :group
  has_many :payers, dependent: :destroy
  accepts_nested_attributes_for :payers, reject_if: :all_blank

  before_save :save_amount
  after_create :save_borrowed_amt

  def is_involved? user_id
  	payers.where(status: true, user_id: user_id).present?
  end

  def payments_made(user)
    payers.where(user_id: user_id).sum(&:amount)
  end

  def avg_amount_per_user
  	( amount.to_f / payers.where(status: true).count )
  end

  def save_amount
    _amount = payers.map(&:amount).compact.sum(:+) rescue 0
    self.amount = _amount
  end

  def save_borrowed_amt
    payers.each do |payer|
      if is_involved?(payer.user.id)
        payer.amt_borrowed =  ( avg_amount_per_user - payer.amount )
      else
        payer.amt_borrowed = 0
      end
      payer.save
    end
  end
end
