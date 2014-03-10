/*
 * main.cpp
 *
 *  Created on: 2014-3-4
 *      Author: xiaobin
 */

#include <vector>
#include <boost/shared_ptr.hpp>
#include <boost/thread.hpp>
#include <boost/bind.hpp>
#include <boost/program_options.hpp>
#include "client.h"
#include "ioservicepool.h"
#include "packet.pb.h"

#define LOG_TAG "main"
#include "XLLogger.h"

#define CLIENT_COUNT		1
#define RUNNING_TIME		60
#define PACKAGE_COUNT	100

typedef boost::shared_ptr<client> client_ptr;
typedef std::vector<client_ptr> client_vector;

using namespace boost;

int main(int argc, char *argv[]) {
	try {
		XLLogger::Instance()->InitLogger(argv[0]);

		io_service_pool pool(CLIENT_COUNT);
		client_vector clients;
		for (int i = 0; i < CLIENT_COUNT; ++i) {
			// client
			LOGT("Create client "<<i);
			client_ptr client_(new client(pool.get_io_service(), "127.0.0.1", "44444"));
			clients.push_back(client_);
		}
		boost::thread thread_(boost::bind(&io_service_pool::run, &pool));

		sleep(1);

		for (int j = 0; j < PACKAGE_COUNT; ++j) {
			Message message;
			message.set_msg("Hello World!");
			Packet pkt;
			pkt.set_version(1);
			pkt.set_command(Packet::kCommandMessage);
			pkt.set_serialized(message.SerializeAsString());
			clients[0]->SendPacket(pkt);
		}
		sleep(RUNNING_TIME);
		pool.stop();
		thread_.join();
	} catch (const std::exception& e) {
		LOGE("Catch exception: "<<e.what());
	} catch (...) {
		LOGE("Catch unknown exception!");
	}
	return 0;
}
