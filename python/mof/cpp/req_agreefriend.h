#ifndef MOF_REQ_AGREEFRIEND_H
#define MOF_REQ_AGREEFRIEND_H

class req_agreefriend{
public:
	void decode(ByteArray &);
	void ~req_agreefriend();
	void PacketName(void);
	void req_agreefriend(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif