/*
 * XLLoggerTest.h
 *
 *  Created on: 2014-3-11
 *      Author: xiaobin
 */

#ifndef XLLOGGERTEST_H_
#define XLLOGGERTEST_H_

#include <gtest/gtest.h>

class XLLoggerTest: public testing::Test {
public:
	XLLoggerTest();
	virtual ~XLLoggerTest();

	// Sets up the test fixture.
	virtual void SetUp();

	// Tears down the test fixture.
	virtual void TearDown();
};

#endif /* XLLOGGERTEST_H_ */
