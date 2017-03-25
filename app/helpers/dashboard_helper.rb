module DashboardHelper
	def event_date _date
		_date.strftime("%b %d, %Y")
	end

	def bill_details
		"#{@bill.event} @#{@bill.location} on Dated #{@bill.event_date.strftime('%b %d, %Y')}"
	end

	def set_status _status
		_status ? "Involved" : "Not Involved"
	end

	def settelment_amount payer
		if !payer.status
			"#{payer.user.name} Not Involved"
		elsif payer.amt_borrowed < 0
			"#{payer.user.name} owes #{number_to_currency(payer.amt_borrowed * -1)}"	
		else
			"#{payer.user.name} borrowed #{number_to_currency(payer.amt_borrowed)}"
		end
	end
end
