#ifndef MOF_REQ_GIVEUPQUEST_H
#define MOF_REQ_GIVEUPQUEST_H

class req_giveupQuest{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_giveupQuest();
	void req_giveupQuest(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif