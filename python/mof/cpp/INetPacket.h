#ifndef MOF_INETPACKET_H
#define MOF_INETPACKET_H

class INetPacket{
public:
	void decode(ByteArray &);
	void ~INetPacket();
	void encode(ByteArray &);
	void build(ByteArray &);
}
#endif