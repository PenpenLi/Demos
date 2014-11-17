#ifndef MOF_ACK_BUY_PVPTIMES_H
#define MOF_ACK_BUY_PVPTIMES_H

class ack_buy_pvptimes{
public:
	void ack_buy_pvptimes(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_buy_pvptimes();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif