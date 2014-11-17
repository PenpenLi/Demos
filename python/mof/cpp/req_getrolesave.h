#ifndef MOF_REQ_GETROLESAVE_H
#define MOF_REQ_GETROLESAVE_H

class req_getrolesave{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_getrolesave(void);
	void ~req_getrolesave();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif