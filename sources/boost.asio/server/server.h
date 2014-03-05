/*
 * server.h
 *
 *  Created on: 2014-3-5
 *      Author: xiaobin
 */

#ifndef SERVER_H_
#define SERVER_H_

#include <string>
#include <vector>
#include <boost/asio.hpp>
#include <boost/noncopyable.hpp>
#include <boost/shared_ptr.hpp>
#include "connection.h"
#include "ioservicepool.h"

class server: private boost::noncopyable {
public:
	/// Construct the server to listen on the specified TCP address and port
	explicit server(int port, int io_service_pool_size);
	virtual ~server();

	/// Run the server's io_service loop.
	void run();

protected:
	/// Initiate an asynchronous accept operation.
	void start_accept();

	/// Handle completion of an asynchronous accept operation.
	void handle_accept(const boost::system::error_code& e);

	/// Handle a request to stop the server.
	void handle_stop();

	/// The pool of io_service objects used to perform asynchronous operations.
	io_service_pool io_service_pool_;

	/// The signal_set is used to register for process termination notifications.
	boost::asio::signal_set signals_;

	/// Acceptor used to listen for incoming connections.
	boost::asio::ip::tcp::acceptor acceptor_;

	/// The next connection to be accepted.
	connection_ptr new_connection_;

	uint64_t connection_id_;

	/// The handler for all incoming requests.
};

#endif /* SERVER_H_ */
