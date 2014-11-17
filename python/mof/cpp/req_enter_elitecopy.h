#ifndef MOF_REQ_ENTER_ELITECOPY_H
#define MOF_REQ_ENTER_ELITECOPY_H

class req_enter_elitecopy{
public:
	void decode(ByteArray	&);
	void ~req_enter_elitecopy();
	void PacketName(void);
	void req_enter_elitecopy(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif