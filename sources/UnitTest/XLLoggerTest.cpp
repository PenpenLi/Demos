/*
 * XLLoggerTest.cpp
 *
 *  Created on: 2014-3-11
 *      Author: xiaobin
 */

#include "XLLoggerTest.h"
#define LOG_TAG "XLLoggerTest"
#include "XLLogger.h"

XLLoggerTest::XLLoggerTest() {
	// TODO Auto-generated constructor stub

}

XLLoggerTest::~XLLoggerTest() {
	// TODO Auto-generated destructor stub
}

// Sets up the test fixture.
void XLLoggerTest::SetUp() {
	LOGT("SetUp");
}

// Tears down the test fixture.
void XLLoggerTest::TearDown() {
	LOGT("TearDown");
}

TEST_F(XLLoggerTest, testLogger) {
	LOGT("Trace log.");
	LOGD("Debug log.");
	LOGI("Hello"<<" World!");
	LOGW("Warn: "<<123<<"!");
	LOGE("Error: code="<<"-0x1111");
	LOGF("Fatal: 严重错误，程序退出！code="<<0xfffffff);
}
