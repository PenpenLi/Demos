#ifndef MOF_REQ_DEATTACHEQUIP_H
#define MOF_REQ_DEATTACHEQUIP_H

class req_deattachEquip{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_deattachEquip();
	void req_deattachEquip(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif