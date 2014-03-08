/*
 * main.cpp
 *
 *  Created on: 2014-3-4
 *      Author: xiaobin
 */

#include <vector>
#include <boost/shared_ptr.hpp>
#include "client.h"
#include "ioservicepool.h"

#define LOG_TAG "main"
#include "XLLogger.h"

#define CLIENT_COUNT	200

typedef boost::shared_ptr<client> client_ptr;
typedef std::vector<client_ptr> client_vector;

int main(int argc, char *argv[]) {
	try {
		XLLogger::Instance()->InitLogger(argv[0]);

		io_service_pool pool(CLIENT_COUNT);
		client_vector clients;
		for (int i=0; i < CLIENT_COUNT; ++i) {
			// client
			LOGT("Create client "<<i);
			client_ptr client_(new client(pool.get_io_service(), "127.0.0.1", "44444"));
			clients.push_back(client_);
		}

		pool.run();
	} catch (const std::exception& e) {
		LOGE("Catch exception: "<<e.what());
	} catch (...) {
		LOGE("Catch unknown exception!");
	}
	return 0;
}
