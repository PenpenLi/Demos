/*
 * XLLoggerTest.cpp
 *
 *  Created on: 2014-3-11
 *      Author: xiaobin
 */

#include "LoggerTest.h"

//#define LOG4CPLUS_DISABLE_TRACE
//#define LOG4CPLUS_DISABLE_DEUBG
//#define LOG4CPLUS_DISABLE_INFO
//#define LOG4CPLUS_DISABLE_WARN
//#define LOG4CPLUS_DISABLE_ERROR
//#define LOG4CPLUS_DISABLE_FATAL
//#define ENABLE_LOG 0
//#define ENABLE_DEBUG_LOG 0
#define LOG_TAG "LoggerTest"
//#include "Logger.h"
#include "log.h"

LoggerTest::LoggerTest() {
	// TODO Auto-generated constructor stub

}

LoggerTest::~LoggerTest() {
	// TODO Auto-generated destructor stub
}

// Sets up the test fixture.
void LoggerTest::SetUp() {
	LOGT("SetUp");
}

// Tears down the test fixture.
void LoggerTest::TearDown() {
	LOGT("TearDown");
}

TEST_F(LoggerTest, testLogger) {
	LOGT("Trace log.");
	LOGD("Debug log.");
	LOGI("Hello" << " World!");
	LOGW("Warn: " << 123 <<"!");
	LOGE("Error: code=" << "-0x1111");
	LOGF("Fatal: 严重错误，程序退出！code="<<0xfffffff);
    printf("printf test\n");
    fprintf(stderr, "fprintf to stderr\n");
    fprintf(stdout, "fprintf to stdout\n");
}
