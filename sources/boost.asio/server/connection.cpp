/*
 * connection.cpp
 *
 *  Created on: 2014-3-4
 *      Author: xiaobin
 */

#include "connection.h"
#include <vector>
#include <boost/bind.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>

#define ENABLE_DEBUG_LOG 0
#define LOG_TAG "connection"
#include "XLLogger.h"

#include "packet.pb.h"
#include "memerypool.hpp"

using namespace boost::asio;
using namespace boost::asio::ip;

#define DEADLINE_TIME	60	//心跳
connection::connection(boost::asio::io_service& io_service, uint64_t connection_id) :
		deadline_(io_service), body_length_(0), socket_(io_service), connection_id_(connection_id) {
	LOGT("connection");
}

connection::~connection() {
	LOGT("~connection");
	shutdown();
}

boost::asio::ip::tcp::socket& connection::socket() {
	return socket_;
}

void connection::start() {
//	// Set a deadline for the read operation.
//	deadline_.expires_from_now(boost::posix_time::seconds(DEADLINE_TIME));
//	deadline_.async_wait(boost::bind(&connection::check_deadline, shared_from_this(), &deadline_));

	// boot reading, read header
	LOGT("Reading header ...");
	async_read(socket_, buffer(header_buffer_, HEADER_LEN),
			boost::bind(&connection::handle_read_header, shared_from_this(), placeholders::error));
}

/// Handle completion of a read header.
void connection::handle_read_header(const boost::system::error_code& error) {
	if (!error) {
		// handle header
		body_length_ = 0;
		memcpy(&body_length_, &header_buffer_[0], HEADER_LEN);

		if (body_length_ < MAX_BODY_LEN) {
			// read body
			LOGT("Reading body, body_length="<<body_length_<<" ...");
			async_read(socket_, buffer(body_buffer_, body_length_),
					boost::bind(&connection::handle_read_body, shared_from_this(), placeholders::error));
		} else {
			LOGE("head format error! body_len="<<body_length_);
			shutdown();
		}
	} else {
		// If an error occurs then no new asynchronous operations are started. This
		// means that all shared_ptr references to the connection object will
		// disappear and the object will be destroyed automatically after this
		// handler returns. The connection class's destructor closes the socket.
		LOGE("read header error: "<<error.message());
		shutdown();
	}
}

/// Handle completion of a read body.
void connection::handle_read_body(const boost::system::error_code& error) {
	if (!error) {
		// handle body
		handle_data(body_buffer_, body_length_);

		// read header again
		LOGT("Reading header ...");
		async_read(socket_, buffer(header_buffer_, HEADER_LEN),
				boost::bind(&connection::handle_read_header, shared_from_this(), placeholders::error));
	} else {
		// If an error occurs then no new asynchronous operations are started. This
		// means that all shared_ptr references to the connection object will
		// disappear and the object will be destroyed automatically after this
		// handler returns. The connection class's destructor closes the socket.
		LOGE("read header error: "<<error.message());
		shutdown();
	}
}

void connection::check_deadline(boost::asio::deadline_timer* deadline) {
	// Check whether the deadline has passed. We compare the deadline against
	// the current time since a new asynchronous operation may have moved the
	// deadline before this actor had a chance to run.
	if (deadline->expires_at() <= boost::asio::deadline_timer::traits_type::now()) {
		// The deadline has passed. Stop the session. The other actors will
		// terminate as soon as possible.
		LOGW("超时未收到心跳包！");
		shutdown();
	}
}

void connection::handle_data(char* data, uint32_t size) {
	LOGT("Handling data ...");
	Packet pkt;
	pkt.ParseFromArray(data, size);
	switch (pkt.command()) {
	case Packet::kCommandHeartbeat: {
		LOGT("Receive kCommandHeartbeat command.");
		deadline_.cancel();
		deadline_.expires_from_now(boost::posix_time::seconds(DEADLINE_TIME));
		deadline_.async_wait(boost::bind(&connection::check_deadline, shared_from_this(), &deadline_));
		break;
	}
	case Packet::kCommandMessage: {
		LOGT("Receive kCommandMessage command.");
		Message message;
		message.ParseFromString(pkt.serialized());
		LOGI("id: " << connection_id_ << ", Message: " << message.msg());

		// response
		boost::posix_time::ptime pt(boost::posix_time::microsec_clock::local_time());
		std::string strRet = boost::posix_time::to_simple_string(pt);
		message.set_msg(strRet);
		Packet retPkt;
		retPkt.set_version(1);
		retPkt.set_command(Packet::kCommandMessage);
		retPkt.set_serialized(message.SerializeAsString());
		int length = retPkt.ByteSize();
		int totalLen = length + 4;
		if (totalLen <= MEMORY_SIZE_8K) {
			char *pkgBuffer = (char *) memory_pool_8k::malloc();
			if (pkgBuffer) {
				memcpy(pkgBuffer, &length, 4);
				retPkt.SerializeToArray(pkgBuffer + 4, length);
				boost::system::error_code ec;
				int writeLen = socket_.write_some(boost::asio::buffer(pkgBuffer, totalLen), ec);
				int current = writeLen;
				while (current < totalLen && !ec) {
					//writeLen >= 0
					writeLen = socket_.write_some(boost::asio::buffer(pkgBuffer + current, totalLen - current), ec);
					current += writeLen;
				}
				if (ec) {
					LOGE("id: " << connection_id_ << ", write error: " << ec.message());
				} else {
					LOGI("id: " << connection_id_ << ", write response OK.");
				}
				memory_pool_8k::free(pkgBuffer);
			} else {
				LOGE("id: " << connection_id_ << ", memery error!");
			}
		} else {
			//todo
			LOGE("id: " << connection_id_ << ", Packet is bigger than memery pool size.");
		}
		break;
	}
	case Packet::kCommandPerson: {
		LOGT("Receive kCommandPerson command.");
		break;
	}
	case Packet::kCommandAddressbook: {
		LOGT("Receive kCommandAddressbook command.");
		break;
	}
	default:
		LOGE("Unknown command: "<<pkt.command()<<"!");
		break;
	}
}

void connection::shutdown() {
	deadline_.cancel();
	boost::system::error_code ec;
	socket_.shutdown(tcp::socket::shutdown_both, ec);
}
