#ifndef MOF_REQ_REALPVP_MEDAL_EXCHANGE_H
#define MOF_REQ_REALPVP_MEDAL_EXCHANGE_H

class req_realpvp_medal_exchange{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void encode(ByteArray &);
	void ~req_realpvp_medal_exchange();
	void build(ByteArray &);
	void req_realpvp_medal_exchange(void);
}
#endif