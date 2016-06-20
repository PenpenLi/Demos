#ifndef SHAREDPTRTEST_H_
#define SHAREDPTRTEST_H_

#include <gtest/gtest.h>

class SharedPtrTest: public testing::Test {
public:
	SharedPtrTest();
	virtual ~SharedPtrTest();

	// Sets up the test fixture.
	virtual void SetUp();

	// Tears down the test fixture.
	virtual void TearDown();
};

#endif
