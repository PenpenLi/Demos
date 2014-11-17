#ifndef MOF_REQ_ATTACHEQUIP_H
#define MOF_REQ_ATTACHEQUIP_H

class req_attachEquip{
public:
	void decode(ByteArray &);
	void req_attachEquip(void);
	void PacketName(void);
	void ~req_attachEquip();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif