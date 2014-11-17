#ifndef MOF_ACK_GET_PRINTCOPY_DATA_H
#define MOF_ACK_GET_PRINTCOPY_DATA_H

class ack_get_printcopy_data{
public:
	void ack_get_printcopy_data(void);
	void ~ack_get_printcopy_data();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif