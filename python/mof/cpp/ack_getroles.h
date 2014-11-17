#ifndef MOF_ACK_GETROLES_H
#define MOF_ACK_GETROLES_H

class ack_getroles{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_getroles(void);
	void build(ByteArray	&);
	void ~ack_getroles();
	void encode(ByteArray &);
}
#endif