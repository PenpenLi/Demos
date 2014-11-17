#ifndef MOF_ACK_ADDFRIEND_H
#define MOF_ACK_ADDFRIEND_H

class ack_addfriend{
public:
	void ~ack_addfriend();
	void ack_addfriend(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif