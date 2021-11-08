//(DunderSocket, network_socket_tcp, "127.0.0.1", 56951);
//env.set_connect_callback(method(self, function() {
//	show_debug_message("connected");	
	
//	env.send_string("hello");
//}));

//env.set_packet_callback(function(_buff, _size) {
//	show_debug_message("pagcket " +string(_size));	
//});


//env.connect();
logger.log_to_file();
logger.info("testing", {x: 1, y: 2});

logger.close_log();