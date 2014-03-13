/*
 * main.cpp
 *
 *  Created on: 2014-3-4
 *      Author: xiaobin
 */

#include <iostream>
#include <vector>
#include <boost/shared_ptr.hpp>
#include <boost/thread.hpp>
#include <boost/bind.hpp>
#include <boost/program_options.hpp>
#include "client.h"
#include "ioservicepool.h"
#include "packet.pb.h"
#include "memerypool.hpp"

#define ENABLE_DEBUG_LOG 0
#define LOG_TAG "main"
#include "XLLogger.h"

#define CLIENT_COUNT		2000
#define RUNNING_TIME		2
#define PACKAGE_COUNT	100

typedef boost::shared_ptr<client> client_ptr;
typedef std::vector<client_ptr> client_vector;

using namespace boost;
namespace po = boost::program_options;

static bool bRun = false;

void callback() {
	LOGT("callback");
	bRun = true;
}

void test(client_ptr client) {
	LOGI("test send message packet ...");
	Message message;
	message.set_msg("Hello World!");
	Packet pkt;
	pkt.set_version(1);
	pkt.set_command(Packet::kCommandMessage);
	pkt.set_serialized(message.SerializeAsString());
	client->SendPacket(pkt);
}

int main(int argc, char *argv[]) {
	try {
		XL::Logger::Instance()->InitLogger(argv[0]);

		po::options_description options("options");
		options.add_options()
				("help,h", "print this help message")
				("version,v", "print version string")
				("client,c", "number of clients, default 1")
				("address,a", "server address")
				("port,p", "server port")
				("time,t", "run for <sec> seconds, default 30");
		po::variables_map vm;
		po::store(po::parse_command_line(argc, argv, options), vm);
		po::notify(vm);
		if (vm.count("help")) {
			std::cout << options << std::endl;
			return 0;
		}

		if (!vm.count("address")) {
			std::cout << "no server address!" << std::endl;
			std::cout << options << std::endl;
			return 1;
		}

		if (!vm.count("port")) {
			std::cout << "no server port!" << std::endl;
			std::cout << options << std::endl;
			return 1;
		}
		XL::Logger::Instance()->SetLogLevel(XL::Logger::LogLevelDebug);

		LOGI(CLIENT_COUNT<<" clients, "<<"runing "<<RUNNING_TIME<<" seconds ...");
		io_service_pool pool(CLIENT_COUNT);
		client_vector clients;
		for (int i = 0; i < CLIENT_COUNT; ++i) {
			// client
			LOGT("Create client "<<i);
			client_ptr client_(
					new client(pool.get_io_service(), vm["address"].as<std::string>(), vm["port"].as<std::string>()));
			clients.push_back(client_);
		}
		boost::thread thread_(boost::bind(&io_service_pool::run, &pool, callback));

		while (!bRun) {
			sleep(1);
		}

//		sleep(5);

		for (int i = 0; i < CLIENT_COUNT; ++i) {
			boost::thread thread_(boost::bind(&test, clients[i]));
		}

		sleep(RUNNING_TIME);

		pool.stop();
		thread_.join();
	} catch (const std::exception& e) {
		LOGE("Catch exception: "<<e.what());
	} catch (...) {
		LOGE("Catch unknown exception!");
	}
	memory_pool_8k::purge_memory();
	return 0;
}
