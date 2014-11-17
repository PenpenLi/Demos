#ifndef MOF_REQ_HANG_UP_H
#define MOF_REQ_HANG_UP_H

class req_hang_up{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void ~req_hang_up();
	void req_hang_up(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif