#include <time.h>
#include <iostream>
#include "thrift/gen-cpp/EchoServer.h"
#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/server/TSimpleServer.h>
#include <thrift/transport/TServerSocket.h>
#include <thrift/transport/TBufferTransports.h>

//test include XLLogger.h first
#include "../libXLLog4j/XLLogger.h"
#undef LOG_TAG
#define LOG_TAG TEXT("EchoServer")

using namespace ::apache::thrift;
using namespace ::apache::thrift::protocol;
using namespace ::apache::thrift::transport;
using namespace ::apache::thrift::server;

using boost::shared_ptr;

class EchoServerHandler : virtual public EchoServerIf {
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
    pszTime[strlen(pszTime)-1] = ' ';  //replace '\n'
    _return = std::string(pszTime) + msg;
  }

  void SendPacket(Packet& _return, const Packet& p) {
    // Your implementation goes here
    static const char *types[] = {
        "Command",
        "Message"
    };
    LOGT("Receive " << types[p.type] << ": " << p.data);
    time_t t;
    time(&t);
    _return.data = ctime(&t);
  }

};

int main(int argc, char **argv) {
    XLLogger::Instance()->InitLogger("echo_server_logger.cfg");
    int port = 9090;
    shared_ptr<EchoServerIf> handler(new EchoServerHandler());
    shared_ptr<TProcessor> processor(new EchoServerProcessor(handler));
    shared_ptr<TServerTransport> serverTransport(new TServerSocket(port));
    shared_ptr<TTransportFactory> transportFactory(new TBufferedTransportFactory());
    shared_ptr<TProtocolFactory> protocolFactory(new TBinaryProtocolFactory());

    TSimpleServer server(processor, serverTransport, transportFactory, protocolFactory);
    server.serve();
    return 0;
}

