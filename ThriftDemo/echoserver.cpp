#include <iostream>
#include "server.h"
#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/server/TSimpleServer.h>
#include <thrift/transport/TServerSocket.h>
#include <thrift/transport/TBufferTransports.h>

using namespace ::apache::thrift;
using namespace ::apache::thrift::protocol;
using namespace ::apache::thrift::transport;
using namespace ::apache::thrift::server;

using boost::shared_ptr;

class serverHandler : virtual public serverIf {
 public:
  serverHandler() {
    // Your initialization goes here
  }

  void echo(const std::string& msg) {
    // Your implementation goes here
      std::cout << "Receive: " << msg << std::endl;
  }

};

int main(int argc, char **argv) {
  int port = 9090;
  shared_ptr<serverHandler> handler(new serverHandler());
  shared_ptr<TProcessor> processor(new serverProcessor(handler));
  shared_ptr<TServerTransport> serverTransport(new TServerSocket(port));
  shared_ptr<TTransportFactory> transportFactory(new TBufferedTransportFactory());
  shared_ptr<TProtocolFactory> protocolFactory(new TBinaryProtocolFactory());

  TSimpleServer server(processor, serverTransport, transportFactory, protocolFactory);
  server.serve();
  return 0;
}

