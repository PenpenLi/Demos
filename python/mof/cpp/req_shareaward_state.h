#ifndef MOF_REQ_SHAREAWARD_STATE_H
#define MOF_REQ_SHAREAWARD_STATE_H

class req_shareaward_state{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_shareaward_state(void);
	void ~req_shareaward_state();
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif