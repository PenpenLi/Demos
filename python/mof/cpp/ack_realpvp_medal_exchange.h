#ifndef MOF_ACK_REALPVP_MEDAL_EXCHANGE_H
#define MOF_ACK_REALPVP_MEDAL_EXCHANGE_H

class ack_realpvp_medal_exchange{
public:
	void ack_realpvp_medal_exchange(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_realpvp_medal_exchange();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif