#ifndef MOF_REQ_GET_PRINTCOPY_DATA_H
#define MOF_REQ_GET_PRINTCOPY_DATA_H

class req_get_printcopy_data{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_get_printcopy_data(void);
	void ~req_get_printcopy_data();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif