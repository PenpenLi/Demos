/*
 * connection.cpp
 *
 *  Created on: 2014-3-4
 *      Author: xiaobin
 */

#include "connection.h"
#include <vector>
#include <boost/bind.hpp>

connection::connection(boost::asio::io_service& io_service, uint64_t connection_id) :
		socket_(io_service), connection_id_(connection_id), body_length_(0), deadline_(io_service) {
}

boost::asio::ip::tcp::socket& connection::socket() {
	return socket_;
}

void connection::start() {
	// Set a deadline for the read operation.
	deadline_.expires_from_now(boost::posix_time::seconds(50));
	deadline_.async_wait(boost::bind(&connection::check_deadline, shared_from_this(), &deadline_));

	boost::asio::async_read(socket_, boost::asio::buffer(header_buffer_, HEADER_LEN),
			boost::bind(&connection::handle_read_header, shared_from_this(), boost::asio::placeholders::error));
}

/// Handle completion of a read header.
void connection::handle_read_header(const boost::system::error_code& error) {

	if (!error) {
		//分包
		memcpy(&body_length_, &header_buffer_[0], HEADER_LEN);

		boost::asio::async_read(socket_, boost::asio::buffer(body_buffer_, body_length_),
				boost::bind(&connection::handle_read_body, shared_from_this(), boost::asio::placeholders::error));
	}

	// If an error occurs then no new asynchronous operations are started. This
	// means that all shared_ptr references to the connection object will
	// disappear and the object will be destroyed automatically after this
	// handler returns. The connection class's destructor closes the socket.
}

/// Handle completion of a read body.
void connection::handle_read_body(const boost::system::error_code& error) {

	if (!error) {
		boost::asio::async_read(socket_, boost::asio::buffer(header_buffer_, HEADER_LEN),
				boost::bind(&connection::handle_read_header, shared_from_this(), boost::asio::placeholders::error));
	}

	// If an error occurs then no new asynchronous operations are started. This
	// means that all shared_ptr references to the connection object will
	// disappear and the object will be destroyed automatically after this
	// handler returns. The connection class's destructor closes the socket.
}

void connection::check_deadline(boost::asio::deadline_timer* deadline) {

}
