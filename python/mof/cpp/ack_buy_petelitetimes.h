#ifndef MOF_ACK_BUY_PETELITETIMES_H
#define MOF_ACK_BUY_PETELITETIMES_H

class ack_buy_petelitetimes{
public:
	void ack_buy_petelitetimes(void);
	void ~ack_buy_petelitetimes();
	void PacketName(void);
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif