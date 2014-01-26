#include <iostream>
#include "EchoServer.h"
#include <thrift/transport/TSocket.h>
#include <thrift/transport/TBufferTransports.h>
#include <thrift/protocol/TBinaryProtocol.h>

using namespace apache::thrift;
using namespace apache::thrift::transport;
using namespace apache::thrift::protocol;

int main(int argc, const char *argv[])
{
    boost::shared_ptr<TSocket> socket(new TSocket("localhost", 9090));
    boost::shared_ptr<TTransport> transport(new TBufferedTransport(socket));
    boost::shared_ptr<TProtocol> protocol(new TBinaryProtocol(transport));

    EchoServerClient client(protocol);
    transport->open();
    std::string msg = "Hello World!";
    std::cout << "echo \"" << msg << "\" to server ..." << std::endl;
    std::string response;
    client.Echo(response, msg);
    std::cout << "Response: " << response << std::endl;

    std::cout << "send packet ..." << std::endl;
    Packet p, ret;
    p.type = PacketType::PacketTypeData;
    p.data = "Hello THrift";
    client.SendPacket(ret, p);
    std::cout << "Response: " << ret.data << std::endl;

    transport->close();
    return 0;
}
