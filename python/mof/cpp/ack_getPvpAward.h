#ifndef MOF_ACK_GETPVPAWARD_H
#define MOF_ACK_GETPVPAWARD_H

class ack_getPvpAward{
public:
	void ack_getPvpAward(void);
	void build(ByteArray &);
	void PacketName(void);
	void decode(ByteArray &);
	void ~ack_getPvpAward();
	void encode(ByteArray &);
}
#endif