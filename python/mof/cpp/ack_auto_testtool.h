#ifndef MOF_ACK_AUTO_TESTTOOL_H
#define MOF_ACK_AUTO_TESTTOOL_H

class ack_auto_testtool{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_auto_testtool();
	void ack_auto_testtool(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif