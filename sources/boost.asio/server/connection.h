/*
 * connection.h
 *
 *  Created on: 2014-3-4
 *      Author: xiaobin
 */

#ifndef CONNECTION_H_
#define CONNECTION_H_

#include <stdint.h>
#include <boost/asio.hpp>
#include <boost/array.hpp>
#include <boost/noncopyable.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/enable_shared_from_this.hpp>
#include <boost/asio/deadline_timer.hpp>

#define HEADER_LEN	4
#define MAX_BODY_LEN	2048

/*!
 * @class connection
 * @brief Represents a single connection from a client.
 */
class connection: public boost::enable_shared_from_this<connection>, private boost::noncopyable {
public:
	/// Construct a connection with the given io_service.
	explicit connection(boost::asio::io_service& io_service, uint64_t connection_id);

	virtual ~connection();

	/// Get the socket associated with the connection.
	boost::asio::ip::tcp::socket& socket();

	/// Start the first asynchronous operation for the connection.
	void start();

protected:
	/// deadline for the async operation.
	boost::asio::deadline_timer deadline_;
	void check_deadline(boost::asio::deadline_timer* deadline);

	/// handle data
	void handle_data(char* data, uint32_t size);

	///////////////////////////////////////////////////////////////////////////
	/// header buffer.
	boost::array<char, HEADER_LEN> header_buffer_;

	/// body buffer
	char body_buffer_[MAX_BODY_LEN];
	/// body length
	uint32_t body_length_;

	/// Handle completion of a read header.
	void handle_read_header(const boost::system::error_code& error);

	/// Handle completion of a read body.
	void handle_read_body(const boost::system::error_code& error);
	///////////////////////////////////////////////////////////////////////////

	/// Socket for the connection.
	boost::asio::ip::tcp::socket socket_;

	uint64_t connection_id_;

	void shutdown();

	/// The incoming request.
	/// The parser for the incoming request.
	/// The handler used to process the incoming request.
	/// The reply to be sent back to the client.
};

typedef boost::shared_ptr<connection> connection_ptr;

#endif /* CONNECTION_H_ */
