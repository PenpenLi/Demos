#ifndef MOF_REQ_ENTER_MYSTICALCOPY_H
#define MOF_REQ_ENTER_MYSTICALCOPY_H

class req_enter_mysticalcopy{
public:
	void req_enter_mysticalcopy(void);
	void ~req_enter_mysticalcopy();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif