#ifndef MOF_ACK_TOTEM_IMMOLATION_H
#define MOF_ACK_TOTEM_IMMOLATION_H

class ack_totem_immolation{
public:
	void ~ack_totem_immolation();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray	&);
	void ack_totem_immolation(void);
	void encode(ByteArray &);
}
#endif