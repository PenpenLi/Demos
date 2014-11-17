#ifndef MOF_REQ_BUY_PVPTIMES_H
#define MOF_REQ_BUY_PVPTIMES_H

class req_buy_pvptimes{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_buy_pvptimes();
	void build(ByteArray &);
	void encode(ByteArray &);
	void req_buy_pvptimes(void);
}
#endif