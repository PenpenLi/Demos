#ifndef MOF_REQ_ENTER_TLK_COPY_H
#define MOF_REQ_ENTER_TLK_COPY_H

class req_enter_tlk_copy{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_enter_tlk_copy(void);
	void ~req_enter_tlk_copy();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif