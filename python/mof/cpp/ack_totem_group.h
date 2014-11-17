#ifndef MOF_ACK_TOTEM_GROUP_H
#define MOF_ACK_TOTEM_GROUP_H

class ack_totem_group{
public:
	void ~ack_totem_group();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ack_totem_group(void);
}
#endif