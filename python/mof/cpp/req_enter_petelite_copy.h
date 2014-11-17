#ifndef MOF_REQ_ENTER_PETELITE_COPY_H
#define MOF_REQ_ENTER_PETELITE_COPY_H

class req_enter_petelite_copy{
public:
	void ~req_enter_petelite_copy();
	void decode(ByteArray &);
	void PacketName(void);
	void req_enter_petelite_copy(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif