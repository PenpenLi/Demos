#ifndef MOF_REQ_BUY_PETELITETIMES_H
#define MOF_REQ_BUY_PETELITETIMES_H

class req_buy_petelitetimes{
public:
	void req_buy_petelitetimes(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_buy_petelitetimes();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif