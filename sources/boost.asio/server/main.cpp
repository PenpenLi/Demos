/*
 * main.cpp
 *
 *  Created on: 2014-3-4
 *      Author: xiaobin
 */

#define LOG_TAG "main"
#include "XLLogger.h"

#include "server.h"
#include <boost/thread.hpp>

int main(int argc, char *argv[]) {
	int result = 0;
	try {
		XLLogger::Instance()->InitLogger(argv[0]);
		server s(44444, boost::thread::hardware_concurrency() + 2);
		s.run();
	} catch (const std::exception& e) {
		LOGE("Catch exception: "<<e.what());
		result = 1;
	} catch (...) {
		LOGE("Catch unknown exception!");
		result = -1;
	}
	return result;
}
