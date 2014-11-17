#ifndef MOF_REQ_FUSIONEQUIP_H
#define MOF_REQ_FUSIONEQUIP_H

class req_fusionEquip{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_fusionEquip();
	void build(ByteArray &);
	void encode(ByteArray &);
	void req_fusionEquip(void);
}
#endif