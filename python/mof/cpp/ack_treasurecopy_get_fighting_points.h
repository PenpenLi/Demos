#ifndef MOF_ACK_TREASURECOPY_GET_FIGHTING_POINTS_H
#define MOF_ACK_TREASURECOPY_GET_FIGHTING_POINTS_H

class ack_treasurecopy_get_fighting_points{
public:
	void ~ack_treasurecopy_get_fighting_points();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_treasurecopy_get_fighting_points(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif