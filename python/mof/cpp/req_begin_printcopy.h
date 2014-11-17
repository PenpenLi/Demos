#ifndef MOF_REQ_BEGIN_PRINTCOPY_H
#define MOF_REQ_BEGIN_PRINTCOPY_H

class req_begin_printcopy{
public:
	void req_begin_printcopy(void);
	void decode(ByteArray	&);
	void ~req_begin_printcopy();
	void PacketName(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif