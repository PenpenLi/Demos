/*
 * client.cpp
 *
 *  Created on: 2014-3-5
 *      Author: xiaobin
 */

#include "client/client.h"
#include <boost/bind.hpp>
#include "packet.pb.h"
#define LOG_TAG "client"
#include "XLLogger.h"

using namespace boost::asio;
using namespace boost::asio::ip;

#define HEARTBEAT_INTERVAL	30
#define RECONNECT_INTERVAL	10

client::client(boost::asio::io_service& io_service, const std::string& address, const std::string& port) :
		socket_(io_service), deadline_(io_service), reconnect_timer_(io_service), server_addr_(address), server_port_(
				port), body_length_(0), io_service_(io_service), is_stop_(false) {
	LOGT("client");
	connect_to_server();
}

client::~client() {
	LOGT("~client");
	Stop();
}

void client::SendPacket(const Packet& pkt) {

}

void client::Stop() {
	is_stop_ = true;
	shutdown();
}

void client::handle_connect(const boost::system::error_code& err) {
	if (!err) {
		LOGT("Connected to server.");
		packet_queue_.clear();
		reconnect_timer_.cancel();
		// read
		LOGT("Reading header ...");
		async_read(socket_, buffer(header_buffer_, HEADER_LEN),
				boost::bind(&client::handle_read_header, this, placeholders::error));

		//
		LOGT("Start heartbeat ...");
		deadline_.expires_from_now(boost::posix_time::seconds(HEARTBEAT_INTERVAL));
		deadline_.async_wait(boost::bind(&client::check_deadline, this, &deadline_));
	} else {
		LOGE("Connect to server error: "<<err.message());
		if (!is_stop_) {
			reconnect();
		}
	}
}

void client::handle_read_header(const boost::system::error_code& err) {
	if (!err) {
		// handle header
		body_length_ = 0;
		memcpy(&body_length_, &header_buffer_[0], HEADER_LEN);

		if (body_length_ < MAX_BODY_LEN) {
			// read body
			LOGT("Reading body, body_length="<<body_length_<<" ...");
			boost::asio::async_read(socket_, boost::asio::buffer(body_buffer_, body_length_),
					boost::bind(&client::handle_read_body, this, boost::asio::placeholders::error));
		} else {
			LOGE("head format error! body_len="<<body_length_);
			shutdown();
		}
	} else {
		// If an error occurs then no new asynchronous operations are started. This
		// means that all shared_ptr references to the connection object will
		// disappear and the object will be destroyed automatically after this
		// handler returns. The connection class's destructor closes the socket.
		LOGE("read header error: "<<err.message());
		shutdown();
	}
}

void client::handle_read_body(const boost::system::error_code& err) {
	if (!err) {
		// handle body

		// read header again
		LOGT("Reading header ...");
		boost::asio::async_read(socket_, boost::asio::buffer(header_buffer_, HEADER_LEN),
				boost::bind(&client::handle_read_header, this, boost::asio::placeholders::error));
	} else {
		// If an error occurs then no new asynchronous operations are started. This
		// means that all shared_ptr references to the connection object will
		// disappear and the object will be destroyed automatically after this
		// handler returns. The connection class's destructor closes the socket.
		LOGE("read header error: "<<err.message());
		shutdown();
	}
}

void client::check_deadline(boost::asio::deadline_timer* deadline) {
	// Check whether the deadline has passed. We compare the deadline against
	// the current time since a new asynchronous operation may have moved the
	// deadline before this actor had a chance to run.
	if (deadline_.expires_at() <= boost::asio::deadline_timer::traits_type::now()) {
		LOGT("心跳时间到。");
		deadline_.expires_from_now(boost::posix_time::seconds(HEARTBEAT_INTERVAL));
		deadline_.async_wait(boost::bind(&client::check_deadline, this, &deadline_));
		Packet pkt;
		pkt.set_command(Packet::kCommandHeartbeat);
		pkt.set_version(1);
		deliver(pkt);
	}
}

void client::handle_reconnect(boost::asio::deadline_timer* deadline) {
	if (reconnect_timer_.expires_at() <= boost::asio::deadline_timer::traits_type::now()) {
		reconnect_timer_.cancel();
		connect_to_server();
	}
}

void client::connect_to_server() {
	LOGT("Connect to server ...");

	tcp::resolver resolver(io_service_);
	tcp::resolver::query query(server_addr_, server_port_);
	tcp::resolver::iterator endpoint_iterator = resolver.resolve(query);
//	ip::tcp::endpoint ep(ip::address::from_string(server_addr_), server_port_);
	async_connect(socket_, endpoint_iterator, boost::bind(&client::handle_connect, this, placeholders::error));
}

void client::deliver(const Packet& pkt) {
	bool bNeedDeliver = packet_queue_.empty();
	packet_queue_.push_back(pkt);
	if (bNeedDeliver) {
		LOGT("Boot first deliver ...");
		int length = pkt.ByteSize();
		memcpy(packet_buffer_, &length, 4);
		pkt.SerializeToArray(packet_buffer_ + 4, length);
		async_write(socket_, buffer(packet_buffer_, (length + 4)),
				boost::bind(&client::handle_deliver, this, placeholders::error));
	}
}

void client::handle_deliver(const boost::system::error_code& err) {
	if (!err) {
		if (packet_queue_.empty()) {
			return;
		}

		packet_queue_.pop_front();
		if (!packet_queue_.empty()) {
			LOGT("Deliver front packet from queue ...");
			int length = packet_queue_.front().ByteSize();
			memcpy(packet_buffer_, &length, 4);
			packet_queue_.front().SerializeToArray(packet_buffer_ + 4, length);
			async_write(socket_, boost::asio::buffer(packet_buffer_, (length + 4)),
					boost::bind(&client::handle_deliver, this, placeholders::error));
		}
	} else {
		LOGE("Deliver packet error: "<<err.message());
		shutdown();
	}
}

void client::shutdown() {
	LOGT("Shutdown connection ...");
	deadline_.cancel();
	boost::system::error_code ec;
	socket_.shutdown(tcp::socket::shutdown_both, ec);
	if (!is_stop_) {
		reconnect();
	}
}

void client::reconnect() {
	LOGI("reconnect ...");
	reconnect_timer_.expires_from_now(boost::posix_time::seconds(RECONNECT_INTERVAL));
	reconnect_timer_.async_wait(boost::bind(&client::handle_reconnect, this, &reconnect_timer_));
}
