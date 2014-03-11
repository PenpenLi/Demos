/*
 * MemeryPoolTest.h
 *
 *  Created on: 2014-3-11
 *      Author: xiaobin
 */

#ifndef MEMERYPOOLTEST_H_
#define MEMERYPOOLTEST_H_

#include <gtest/gtest.h>

class MemeryPoolTest: public testing::Test {
public:
	MemeryPoolTest();
	virtual ~MemeryPoolTest();

	// Sets up the test fixture.
	virtual void SetUp();

	// Tears down the test fixture.
	virtual void TearDown();
};

#endif /* MEMERYPOOLTEST_H_ */
