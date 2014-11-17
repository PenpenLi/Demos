#ifndef MOF_ACK_BUY_ELITETIMES_H
#define MOF_ACK_BUY_ELITETIMES_H

class ack_buy_elitetimes{
public:
	void ack_buy_elitetimes(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~ack_buy_elitetimes();
}
#endif