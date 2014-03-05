/*
 * main.cpp
 *
 *  Created on: 2014-3-4
 *      Author: xiaobin
 */

#define LOG_TAG "main"
#include "XLLogger.h"

#include "client.h"

int main(int argc, char *argv[]) {
	try {
		XLLogger::Instance()->InitLogger(argv[0]);
		boost::asio::io_service io_service_;
		client c(io_service_, "127.0.0.1", "44444");
		io_service_.run();
	} catch (const std::exception& e) {
		LOGE("Catch exception: "<<e.what());
	} catch (...) {
		LOGE("Catch unknown exception!");
	}
	return 0;
}
