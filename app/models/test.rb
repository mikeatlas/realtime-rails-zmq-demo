class Test

	require 'em-zeromq'

	def run_subscriber

		EM.run {
			zmq = EM::ZeroMQ::Context.new(1)
			subscriber = zmq.socket(ZMQ::SUB)
			
			subscriber.subscribe('realtime_msg:')

			subscriber.connect("tcp://zmq-server.mikeatlas.com:5557")
	  		
	  		subscriber.on(:message) { |part|
				published_message = part.copy_out_string
				message = published_message.split('realtime_msg:')[1]
				parsed_message = JSON.parse(message)
				puts 'Subscriber got message: ' + parsed_message["msg"].inspect
				part.close
			}
	  	}
	end

	def run_pusher

		EM.run {
			zmq = EM::ZeroMQ::Context.new(1)
			pusher = zmq.socket(ZMQ::PUSH)
			pusher.connect("tcp://zmq-server.mikeatlas.com:5556")

			EM.add_periodic_timer(1) {
				message = "realtime_msg:" + {msg: "Hello World - #{DateTime.now.to_s}"}.to_json
				puts "Pushing message: " + message
    			pusher.send_msg(message)
  			}
	  	}
	end


end