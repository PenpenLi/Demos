#ifndef MOF_REQ_LEAVE_MYSTICALCOPY_H
#define MOF_REQ_LEAVE_MYSTICALCOPY_H

class req_leave_mysticalcopy{
public:
	void req_leave_mysticalcopy(void);
	void ~req_leave_mysticalcopy();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif