class GroupsController < ApplicationController
  before_action :set_bill, only: [:show]

  def show
    @bills = @group.bills.order(event_date: :desc)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_attribuites)
    @group.members << @group.members.build(user_id: current_user.email)
    @group.save
    redirect_to group_path(@group)
  end

  private

  def set_bill
    @group = Group.find params[:id]
  end

  def group_attribuites
    params.require(:group).permit(:name, :description, members_attributes: [:id, :user_id, :_destroy])
  end
end
