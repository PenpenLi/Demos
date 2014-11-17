#ifndef MOF_REQ_VIPAWARD_H
#define MOF_REQ_VIPAWARD_H

class req_vipaward{
public:
	void req_vipaward(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_vipaward();
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif