/*
 * MemeryPoolTest.cpp
 *
 *  Created on: 2014-3-11
 *      Author: xiaobin
 */

#include "MemeryPoolTest.h"
#include "memerypool.hpp"

MemeryPoolTest::MemeryPoolTest() {
	// TODO Auto-generated constructor stub

}

MemeryPoolTest::~MemeryPoolTest() {
	// TODO Auto-generated destructor stub
}

// Sets up the test fixture.
void MemeryPoolTest::SetUp() {
}

// Tears down the test fixture.
void MemeryPoolTest::TearDown() {
	memory_pool_8k::purge_memory();
}

TEST_F(MemeryPoolTest, testMemeryPool) {
	for (int i=0; i<1000; ++i) {
		char *data = (char *)memory_pool_8k::malloc();
		ASSERT_TRUE(data != NULL);
	}
}
