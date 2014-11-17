#ifndef MOF_REQ_BUY_ELITETIMES_H
#define MOF_REQ_BUY_ELITETIMES_H

class req_buy_elitetimes{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_buy_elitetimes(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~req_buy_elitetimes();
}
#endif