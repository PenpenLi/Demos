#ifndef MOF_REQ_FINISHQUEST_H
#define MOF_REQ_FINISHQUEST_H

class req_finishQuest{
public:
	void ~req_finishQuest();
	void decode(ByteArray &);
	void PacketName(void);
	void req_finishQuest(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif