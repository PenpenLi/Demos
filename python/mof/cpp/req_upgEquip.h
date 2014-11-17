#ifndef MOF_REQ_UPGEQUIP_H
#define MOF_REQ_UPGEQUIP_H

class req_upgEquip{
public:
	void req_upgEquip(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_upgEquip();
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif