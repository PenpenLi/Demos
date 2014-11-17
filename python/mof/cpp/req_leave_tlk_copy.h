#ifndef MOF_REQ_LEAVE_TLK_COPY_H
#define MOF_REQ_LEAVE_TLK_COPY_H

class req_leave_tlk_copy{
public:
	void req_leave_tlk_copy(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_leave_tlk_copy();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif