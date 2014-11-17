#ifndef MOF_REQ_PASS_MYSTICALCOPY_H
#define MOF_REQ_PASS_MYSTICALCOPY_H

class req_pass_mysticalcopy{
public:
	void req_pass_mysticalcopy(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_pass_mysticalcopy();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif