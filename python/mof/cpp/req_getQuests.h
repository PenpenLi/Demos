#ifndef MOF_REQ_GETQUESTS_H
#define MOF_REQ_GETQUESTS_H

class req_getQuests{
public:
	void req_getQuests(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_getQuests();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif