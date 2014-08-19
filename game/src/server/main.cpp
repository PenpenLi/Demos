/*!
 * @file main.cpp
 *  Created on: 2014-3-4
 *
 * @author: lxb
 */

#include <boost/thread.hpp>
#include "memerypool.hpp"
#include "server.h"

#define LOG_TAG "main"
#include "Logger.h"

int main(int argc, char *argv[]) {
	int result = 0;
    XL::Logger::Instance()->InitLogger(argv[0]);
	try {
		server s(44444, boost::thread::hardware_concurrency() + 2);
		s.run();
	} catch (const std::exception& e) {
		LOGE("Catch exception: "<<e.what());
		result = 1;
	} catch (...) {
		LOGE("Catch unknown exception!");
		result = -1;
	}

	memory_pool_8k::purge_memory();
	return result;
}
