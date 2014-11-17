#ifndef MOF_REQ_PRINTCOPY_RESET_H
#define MOF_REQ_PRINTCOPY_RESET_H

class req_printcopy_reset{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void ~req_printcopy_reset();
	void encode(ByteArray	&);
	void build(ByteArray &);
	void req_printcopy_reset(void);
}
#endif