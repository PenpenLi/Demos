#include <time.h>
#include <iostream>
#include "thrift/gen-cpp/EchoServer.h"

#include <thrift/concurrency/ThreadManager.h>
#include <thrift/concurrency/PosixThreadFactory.h>

#include <thrift/protocol/TBinaryProtocol.h>

#include <thrift/server/TNonblockingServer.h>
//#include <thrift/server/TSimpleServer.h>
#include <thrift/server/TThreadPoolServer.h>

//#include <thrift/transport/TServerSocket.h>
//#include <thrift/transport/TBufferTransports.h>

#include <thrift/async/TAsyncProcessor.h>

//test include XLLogger.h first
//#define LOGGER_NAME TEXT("EchoServer")
#include "XLLogger.h"
#undef LOG_TAG
#define LOG_TAG TEXT("EchoServer")

using namespace ::apache::thrift;
using namespace ::apache::thrift::protocol;
using namespace ::apache::thrift::transport;

using ::apache::thrift::async::TAsyncProcessor;

using ::apache::thrift::server::TNonblockingServer;
using ::apache::thrift::server::TThreadPoolServer;

using ::apache::thrift::concurrency::ThreadFactory;
using ::apache::thrift::concurrency::PosixThreadFactory;
using ::apache::thrift::concurrency::ThreadManager;

using boost::shared_ptr;

class EchoServerHandler: virtual public EchoServerIf {
public:
	EchoServerHandler() {
		// Your initialization goes here
	}

	void Echo(std::string& _return, const std::string& msg) {
		// Your implementation goes here
		LOGT("Receive: " << msg);
		time_t t;
		time(&t);
		char *pszTime = ctime(&t);
		pszTime[strlen(pszTime) - 1] = ' ';  //replace '\n'
		_return = std::string(pszTime) + msg;
	}

	void SendPacket(Packet& _return, const Packet& p) {
		// Your implementation goes here
		static const char *types[] = { "Command", "Message" };
		LOGT("Receive " << types[p.type] << ": " << p.data);
		time_t t;
		time(&t);
		_return.data = ctime(&t);
	}

	void HelloString(std::string& _return, const std::string& para) {
		// Your implementation goes here
		LOGT("HelloString: "<<para);
		_return = para;
	}

	int32_t HelloInt(const int32_t para) {
		// Your implementation goes here
		LOGT("HelloInt: "<<para);
		return para;
	}

	bool HelloBool(const bool para) {
		// Your implementation goes here
		LOGT("HelloBool: "<<para);
		return para;
	}

	int64_t HelloInt64(const int64_t para) {
		// Your implementation goes here
		LOGT("HelloInt64: "<<para);
		return para;
	}

	void HelloVoid() {
		// Your implementation goes here
		LOGT("HelloVoid");
	}

	void HelloNull(std::string& _return) {
		// Your implementation goes here
		LOGT("HelloNull");
		time_t t;
		time(&t);
		_return = ctime(&t);
	}

};

int main(int argc, char **argv) {
	XLLogger::Instance()->InitLogger(argv[0]);
	int port = 9090;

	shared_ptr<EchoServerIf> handler(new EchoServerHandler());
	shared_ptr<TProcessor> processor(new EchoServerProcessor(handler));
	shared_ptr<TProtocolFactory> protocolFactory(new TBinaryProtocolFactory());
	shared_ptr<TServerTransport> serverTransport(new TServerSocket(port));
	shared_ptr<TTransportFactory> transportFactory(new TBufferedTransportFactory());

	///*
	//nonblocking server
	shared_ptr<ThreadManager> threadManager = ThreadManager::newSimpleThreadManager(4);
	shared_ptr<ThreadFactory> threadFactory(new PosixThreadFactory());
	threadManager->threadFactory(threadFactory);
	threadManager->start();
	TNonblockingServer server(processor, protocolFactory, port, threadManager);
	//*/

	/*
	 //simple server
	 TSimpleServer server(processor, serverTransport, transportFactory, protocolFactory);
	 */

	/*
	 //thread poor server
	 boost::shared_ptr<ThreadManager> threadManager =
	 ThreadManager::newSimpleThreadManager(4);
	 boost::shared_ptr<PosixThreadFactory> threadFactory = boost::shared_ptr<
	 PosixThreadFactory>(new PosixThreadFactory());
	 threadManager->threadFactory(threadFactory);
	 threadManager->start();
	 TThreadPoolServer server(processor, serverTransport, transportFactory,
	 protocolFactory, threadManager);
	 */

	LOGT("Start server ...");
	server.serve();
	LOGT("Done.");
	return 0;
}

