#ifndef MOF_REQ_PING_H
#define MOF_REQ_PING_H

class req_ping{
public:
	void decode(ByteArray &);
	void ~req_ping();
	void PacketName(void);
	void req_ping(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif