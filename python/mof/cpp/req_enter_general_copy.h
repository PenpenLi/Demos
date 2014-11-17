#ifndef MOF_REQ_ENTER_GENERAL_COPY_H
#define MOF_REQ_ENTER_GENERAL_COPY_H

class req_enter_general_copy{
public:
	void req_enter_general_copy(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_enter_general_copy();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif