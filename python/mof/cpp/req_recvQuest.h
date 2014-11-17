#ifndef MOF_REQ_RECVQUEST_H
#define MOF_REQ_RECVQUEST_H

class req_recvQuest{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_recvQuest();
	void req_recvQuest(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif