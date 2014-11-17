#ifndef MOF_REQ_FINISH_FAMESHALL_H
#define MOF_REQ_FINISH_FAMESHALL_H

class req_finish_famesHall{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_finish_famesHall(void);
	void ~req_finish_famesHall();
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif