class SettlementInfo
  def initialize(expenses = {}, user_id)
    @expenses = expenses
    @user_id = user_id
    @amount = expenses[user_id]
  end

  def find_user(user_id = @user_id)
    User.find user_id
  end

  def check_already_settle_up?
    @messages.push 'Your Bill Already Settled'
  end

  def settleup_messages
    @messages = []
    check_already_settle_up? if @amount == 0
    @expenses.each do |user_id, amt|
      next if user_id == @user_id
      break if @amount == 0

      @bill_user = find_user user_id
      if @amount < 0
        levelup_owes_bill(amt)
      else
        levelup_borrows_bill(amt)
      end
    end
    @messages
  end

  def levelup_owes_bill(amt)
    if amt > 0
      @amount += amt
      if @amount > 0
        @amount = (@expenses[@user_id] * -1).round(2)
        @messages.push "#{find_user.name} Owes #{@bill_user.name} $#{@amount}"
        @expenses[@user_id] = 0
        @expenses[@bill_user.id] = @amount
        @amount = 0
      else
        @expenses[@bill_user.id] = 0
        @expenses[@user_id] = @amount
        @messages.push "#{find_user.name} Owes #{@bill_user.name} $#{amt.round(2)}"
      end
    end
  end

  def levelup_borrows_bill(amt)
    if amt < 0
      @amount += amt
      if @amount < 0
        @expenses[@user_id] = 0
        @expenses[@bill_user.id] = @amount
        bill_amt = ( amt - @amount ).round(2)
        @messages.push "#{find_user.name} borrows #{@bill_user.name} $#{bill_amt * -1} "
        @amount = 0
      else
        @expenses[@bill_user.id] = 0
        @expenses[@user_id] = @amount
        @messages.push "#{find_user.name} borrows #{@bill_user.name} $#{(amt * -1).round(2)} "
      end
    end
  end
end
