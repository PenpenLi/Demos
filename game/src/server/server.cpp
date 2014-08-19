/*
 * server.cpp
 *
 *  Created on: 2014-3-5
 *      Author: xiaobin
 */

#include "server.h"
#include <boost/bind.hpp>

#define ENABLE_DEBUG_LOG 1
#define LOG_TAG "server"
#include "Logger.h"

server::server(int port, int io_service_pool_size) :
		io_service_pool_(io_service_pool_size), signals_(io_service_pool_.get_io_service()), acceptor_(
				io_service_pool_.get_io_service()), new_connection_(), connection_id_(0) {
	LOGT("server");
	LOGT("Register signals ...");
	// Register to handle the signals that indicate when the server should exit.
	// It is safe to register for the same signal multiple times in a program,
	// provided all registration for the specified signal is made through Asio.
	signals_.add(SIGINT);
	signals_.add(SIGTERM);
#if defined(SIGQUIT)
	signals_.add(SIGQUIT);
#endif // defined(SIGQUIT)
	signals_.async_wait(boost::bind(&server::handle_stop, this));

	LOGT("Set up acceptor ...");
	boost::asio::ip::tcp::endpoint endpoint(boost::asio::ip::tcp::v4(), port);
	acceptor_.open(endpoint.protocol());
	acceptor_.set_option(boost::asio::ip::tcp::acceptor::reuse_address(true));
	acceptor_.bind(endpoint);
	acceptor_.listen();

	start_accept();
}

server::~server() {
	LOGT("~server");
}

void server::run() {
	LOGI("running ...");
	io_service_pool_.run();
	LOGI("exit.");
}

void server::start_accept() {
	//>= 2^ 62
	++connection_id_;
	if ((connection_id_ >= 4611686018427387904) || (connection_id_ <= 0)) {
		connection_id_ = 1;
	}
	LOGT("start_accept, connection_id="<<connection_id_);
	//前一个connection不会释放吗？为什么？ connection.start... 通过shared_from_this引用？
	LOGT("connection reference count: "<<new_connection_.use_count());
	new_connection_.reset(new connection(io_service_pool_.get_io_service(), connection_id_));
	LOGT("connection reference count: "<<new_connection_.use_count());
	acceptor_.async_accept(new_connection_->socket(),
			boost::bind(&server::handle_accept, this, boost::asio::placeholders::error));
}

void server::handle_accept(const boost::system::error_code& e) {
	if (!e) {
		// handle connection
		LOGI("new connection, id="<<new_connection_->connection_id());
		LOGT("Handle new connection ...");
		LOGT("connection reference count: "<<new_connection_.use_count());
		new_connection_->start();
		LOGT("connection reference count after start: "<<new_connection_.use_count());
	}

	// accept again
	start_accept();
}

void server::handle_stop() {
	boost::system::error_code ec;
	acceptor_.close(ec);
	acceptor_.cancel(ec);
	io_service_pool_.stop();
}
