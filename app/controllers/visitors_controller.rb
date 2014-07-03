class VisitorsController < ApplicationController
	require 'em-zeromq'

	def trigger_realtime_message

		ZmqWrapper.publish({msg: "Hello World - #{DateTime.now.to_s}",
				 recipient_user_ids: [41, 42] })

		head :no_content
	end

end
