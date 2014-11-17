#ifndef MOF_ACK_GETPVPRANK_H
#define MOF_ACK_GETPVPRANK_H

class ack_getPvpRank{
public:
	void ack_getPvpRank(void);
	void ~ack_getPvpRank();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif