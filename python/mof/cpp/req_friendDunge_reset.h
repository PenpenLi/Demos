#ifndef MOF_REQ_FRIENDDUNGE_RESET_H
#define MOF_REQ_FRIENDDUNGE_RESET_H

class req_friendDunge_reset{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_friendDunge_reset(void);
	void ~req_friendDunge_reset();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif