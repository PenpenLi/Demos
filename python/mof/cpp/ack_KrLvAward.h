#ifndef MOF_ACK_KRLVAWARD_H
#define MOF_ACK_KRLVAWARD_H

class ack_KrLvAward{
public:
	void ~ack_KrLvAward();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ack_KrLvAward(void);
}
#endif