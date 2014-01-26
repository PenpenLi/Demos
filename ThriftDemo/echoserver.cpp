#include <time.h>
#include <iostream>
#include "EchoServer.h"
#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/server/TSimpleServer.h>
#include <thrift/transport/TServerSocket.h>
#include <thrift/transport/TBufferTransports.h>

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
    std::cout << "Receive: " << msg << std::endl;
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
    std::cout << "Receive " << types[p.type] << ": " << p.data << std::endl;
    time_t t;
    time(&t);
    _return.data = ctime(&t);
  }

};

int main(int argc, char **argv) {
  int port = 9090;
  shared_ptr<EchoServerHandler> handler(new EchoServerHandler());
  shared_ptr<TProcessor> processor(new EchoServerProcessor(handler));
  shared_ptr<TServerTransport> serverTransport(new TServerSocket(port));
  shared_ptr<TTransportFactory> transportFactory(new TBufferedTransportFactory());
  shared_ptr<TProtocolFactory> protocolFactory(new TBinaryProtocolFactory());

  TSimpleServer server(processor, serverTransport, transportFactory, protocolFactory);
  server.serve();
  return 0;
}

