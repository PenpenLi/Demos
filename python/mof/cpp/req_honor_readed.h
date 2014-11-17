#ifndef MOF_REQ_HONOR_READED_H
#define MOF_REQ_HONOR_READED_H

class req_honor_readed{
public:
	void req_honor_readed(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_honor_readed();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif