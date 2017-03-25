class BillsController < ApplicationController
  before_action :set_group, only: [:new, :show, ]

  def index
  end

  def show
  	@bill = Bill.find params[:id]
  end

  def new
  	@bill = @group.bills.new
  	@group.users.each do |user|
  		@bill.payers.build(user_id: user.id, group_id: @group.id )
  	end
  end

  def create
  	@bill = Bill.new(bill_params)
  	@bill.save
  	redirect_to @bill.group
  end

  private

  def set_group
  	@group = Group.find params[:group_id]
  end

  def bill_params
  	params.require(:bill).permit(:event, :group_id, :description, :location, :event_date, payers_attributes: [:id, :user_id, :amount, :status, :group_id,  :_destroy])
  end
end
