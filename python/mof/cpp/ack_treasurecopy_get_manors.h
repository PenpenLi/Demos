#ifndef MOF_ACK_TREASURECOPY_GET_MANORS_H
#define MOF_ACK_TREASURECOPY_GET_MANORS_H

class ack_treasurecopy_get_manors{
public:
	void ack_treasurecopy_get_manors(void);
	void decode(ByteArray	&);
	void ~ack_treasurecopy_get_manors();
	void PacketName(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif