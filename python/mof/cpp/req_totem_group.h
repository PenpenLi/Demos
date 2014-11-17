#ifndef MOF_REQ_TOTEM_GROUP_H
#define MOF_REQ_TOTEM_GROUP_H

class req_totem_group{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_totem_group();
	void req_totem_group(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif