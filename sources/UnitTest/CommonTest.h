/*
 * CommonTest.h
 *
 *  Created on: 2014-3-13
 *      Author: xiaobin
 */

#ifndef XLCOMMONTEST_H_
#define XLCOMMONTEST_H_

#include <gtest/gtest.h>

namespace XL {

class CommonTest: public testing::Test {
public:
	CommonTest();
	virtual ~CommonTest();
	// Sets up the test fixture.
	virtual void SetUp();

	// Tears down the test fixture.
	virtual void TearDown();
};

} /* namespace XL */
#endif /* XLCOMMONTEST_H_ */
