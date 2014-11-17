#ifndef MOF_REQ_ADDFRIEND_H
#define MOF_REQ_ADDFRIEND_H

class req_addfriend{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_addfriend(void);
	void ~req_addfriend();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif