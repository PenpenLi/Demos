/*
 * CDemo.cpp
 *
 *  Created on: 2014-2-19
 *      Author: xiaobin
 */

#include "CDemo.h"
#define LOG_TAG TEXT("CDemo")
#include "XLLogger.h"

#include <boost/date_time/posix_time/posix_time.hpp>

CDemo::CDemo() {
	LOGT("CDemo()");
}

CDemo::~CDemo() {
	LOGT("~CDemo()");
}

void CDemo::Hello() {
	boost::posix_time::ptime pt;
	LOGI("Hello World! time: " << boost::posix_time::to_simple_string(pt));
}
