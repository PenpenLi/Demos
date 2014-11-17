#ifndef MOF_REQ_PLAYERBAG_H
#define MOF_REQ_PLAYERBAG_H

class req_playerbag{
public:
	void req_playerbag(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_playerbag();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif