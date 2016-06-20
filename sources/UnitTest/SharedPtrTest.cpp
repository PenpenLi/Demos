#include "SharedPtrTest.h"

#include <memory>
#include <thread>
#include <chrono>

class Demo : public std::enable_shared_from_this<Demo>
{
public:
	Demo()
	: _testValue(0)
	{
		
	}
	
    void test1()
    {
		std::thread t([this]{
			std::this_thread::sleep_for(std::chrono::microseconds(500));
			++_testValue;
		});
		t.detach();
    }
	
private:
	int _testValue;
};

SharedPtrTest::SharedPtrTest() {
}

SharedPtrTest::~SharedPtrTest() {
}

// Sets up the test fixture.
void SharedPtrTest::SetUp() {
}

// Tears down the test fixture.
void SharedPtrTest::TearDown() {
}

TEST_F(SharedPtrTest, Test1Crash)
{
	auto demoPtr = std::make_shared<Demo>();
	ASSERT_EQ(demoPtr.use_count(), 1);
	demoPtr->test1();
}
