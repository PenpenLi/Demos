#include <iostream>
#include "thrift/gen-cpp/EchoServer.h"
#include <thrift/transport/TSocket.h>
#include <thrift/transport/TBufferTransports.h>
#include <thrift/protocol/TBinaryProtocol.h>

#include <boost/thread.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/bind.hpp>
#include <boost/progress.hpp>

//#define LOGGER_NAME TEXT("EchoClient")
#define LOG_TAG TEXT("EchoClient")
#include "XLLogger.h"

using namespace apache::thrift;
using namespace apache::thrift::transport;
using namespace apache::thrift::protocol;

__attribute__((__unused__)) static const int connection_count = 1000;
static int test_count = 4000;

static int g_count = test_count;

void test(int count) {
	--g_count;
//	LOGT("Create client"<<count<<" ...");
	boost::shared_ptr<TTransport> socket(new TSocket("127.0.0.1", 9090));
//	boost::shared_ptr<TTransport> transport(new TBufferedTransport(socket));
	boost::shared_ptr<TTransport> transport(new TFramedTransport(socket));
	boost::shared_ptr<TProtocol> protocol(new TBinaryProtocol(transport));
	transport->open();
	EchoServerClient c(protocol);
	std::ostringstream os;
	os << "test" << count;
	std::string msg = os.str();
//	LOGT("echo \"" << msg << "\" to server ...");
	std::string response;
	c.Echo(response, msg);
//	LOGT("Response: " << response);

//	LOGT("send packet ...");
	Packet p, ret;
	p.type = PacketType::PacketTypeData;
	p.data = msg;
	c.SendPacket(ret, p);
//	LOGT("Response: " << ret.data);
//	int iRet = c.HelloInt(count);
//	LOGT("HelloInt: " << iRet);
	transport->close();
}

int main(int argc, const char *argv[]) {
	XLLogger::Instance()->InitLogger("echo_client_logger.cfg");
	LOGT("Begin test ...");
	try {
//		while(true) {
		boost::progress_timer t;
		LOGI("**线程数: "<<g_count);

		for (int i = 0; i < test_count; ++i) {
			boost::thread testThread(boost::bind(test, i));
		}
		while (g_count) {
			sleep(1);
			LOGT("waiting ...");
		}
		LOGT("**Done.");
//			test_count += 100;
//			g_count = test_count;
//		}
	} catch (const std::exception& e) {
		LOGE("exception: "<<e.what());
	}
	LOGT("end.");
	return 0;
}
