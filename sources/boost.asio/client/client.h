/*
 * client.h
 *
 *  Created on: 2014-3-5
 *      Author: xiaobin
 */

#ifndef CLIENT_H_
#define CLIENT_H_

#include <string>
#include <deque>
#include <boost/asio.hpp>
#include <boost/noncopyable.hpp>
#include "packet.pb.h"

#define HEADER_LEN	4
#define MAX_BODY_LEN	2048

class client: private boost::noncopyable {
public:
	client(boost::asio::io_service& io_service, const std::string& address, const std::string& port);
	virtual ~client();

	void SendPacket(const Packet& pkt);

	void Stop();

protected:

	void handle_connect(const boost::system::error_code& err);

	void handle_read_header(const boost::system::error_code& err);

	void handle_read_body(const boost::system::error_code& err);

	boost::asio::ip::tcp::socket socket_;

	boost::asio::deadline_timer deadline_;
	void check_deadline(boost::asio::deadline_timer* deadline);

	boost::asio::deadline_timer reconnect_timer_;
	void handle_reconnect(boost::asio::deadline_timer* deadline);

private:
	void connect_to_server();
	std::string server_addr_;
	std::string server_port_;

	char header_buffer_[HEADER_LEN];
	char body_buffer_[MAX_BODY_LEN];
	uint32_t body_length_;

	std::deque<Packet> packet_queue_;

	char packet_buffer_[HEADER_LEN + MAX_BODY_LEN];
	void deliver(const Packet& pkt);
	void handle_deliver(const boost::system::error_code& err);

	boost::asio::io_service& io_service_;

	bool is_stop_;

	void shutdown();
	void reconnect();
};

#endif /* CLIENT_H_ */
