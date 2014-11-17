#ifndef MOF_ACK_AGREEFRIEND_H
#define MOF_ACK_AGREEFRIEND_H

class ack_agreefriend{
public:
	void ~ack_agreefriend();
	void ack_agreefriend(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif