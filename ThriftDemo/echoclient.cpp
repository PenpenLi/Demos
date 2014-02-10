#include <iostream>
#include "thrift/gen-cpp/EchoServer.h"
#include <thrift/transport/TSocket.h>
#include <thrift/transport/TBufferTransports.h>
#include <thrift/protocol/TBinaryProtocol.h>

//#define LOGGER_NAME XL_TEXT("EchoClient")
#define LOG_TAG TEXT("EchoClient")
#include "../libXLLog4j/XLLogger.h"

using namespace apache::thrift;
using namespace apache::thrift::transport;
using namespace apache::thrift::protocol;

int main(int argc, const char *argv[])
{
    XLLogger::Instance()->InitLogger("echo_client_logger.cfg");
    boost::shared_ptr<TTransport> socket(new TSocket("localhost", 9090));
    boost::shared_ptr<TTransport> transport(new TBufferedTransport(socket));
    boost::shared_ptr<TProtocol> protocol(new TBinaryProtocol(transport));

    LOGT("Create client ...");
    EchoServerClient client(protocol);
    transport->open();
    std::string msg = "Hello World!";
    LOGT("echo \"" << msg << "\" to server ...");
    std::string response;
    client.Echo(response, msg);
    LOGT("Response: " << response);

    LOGT("send packet ...");
    Packet p, ret;
    p.type = PacketType::PacketTypeData;
    p.data = "Hello THrift";
    client.SendPacket(ret, p);
    LOGT("Response: " << ret.data);

    transport->close();
    return 0;
}
