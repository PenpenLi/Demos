#ifndef MOF_REQ_FINISH_PETELITE_COPY_H
#define MOF_REQ_FINISH_PETELITE_COPY_H

class req_finish_petelite_copy{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_finish_petelite_copy();
	void req_finish_petelite_copy(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif