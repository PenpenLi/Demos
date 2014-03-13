/*
 * CommonTest.cpp
 *
 *  Created on: 2014-3-13
 *      Author: xiaobin
 */

#include "CommonTest.h"
#include <iostream>
#include "HttpClient.h"

namespace XL {

CommonTest::CommonTest() {
	// TODO Auto-generated constructor stub

}

CommonTest::~CommonTest() {
	// TODO Auto-generated destructor stub
}

// Sets up the test fixture.
void CommonTest::SetUp() {

}

// Tears down the test fixture.
void CommonTest::TearDown() {

}

TEST_F(CommonTest, testHttpClient) {
	CHttpClient::HttpClientPtr client = CHttpClient::Create("http://www.baidu.com");
	std::cout << "引用计数：" << client.use_count() << std::endl;
	ASSERT_EQ(client.use_count(), 1);
	bool result = client->SyncGet();
	int code = client->GetErrorCode();
	if (result) {
		std::cout << client->GetResponseString() << std::endl;
	} else {
		std::cout << "Error(" << code << "): " << client->GetErrorMessage() << std::endl;
	}
	ASSERT_TRUE(result);
	std::cout << "code(" << code <<"): " << client->GetErrorMessage() << std::endl;

	//2
	CHttpClient::HttpClientPtr google = CHttpClient::Create("http://www.google.com", true);
	std::cout << "引用计数：" << google.use_count() << std::endl;
	ASSERT_EQ(google.use_count(), 1);
	result = google->SyncGet();
	code = google->GetErrorCode();
	if (result) {
		std::cout << google->GetResponseString() << std::endl;
	} else {
		std::cout << "Error(" << code << "): " << google->GetErrorMessage() << std::endl;
	}
	ASSERT_TRUE(result);
	std::cout << "code(" << code <<"): " << client->GetErrorMessage() << std::endl;
}

} /* namespace XL */
