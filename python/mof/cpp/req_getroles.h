#ifndef MOF_REQ_GETROLES_H
#define MOF_REQ_GETROLES_H

class req_getroles{
public:
	void ~req_getroles();
	void decode(ByteArray &);
	void PacketName(void);
	void req_getroles(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif