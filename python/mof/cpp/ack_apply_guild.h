#ifndef MOF_ACK_APPLY_GUILD_H
#define MOF_ACK_APPLY_GUILD_H

class ack_apply_guild{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_apply_guild();
	void ack_apply_guild(void);
	void encode(ByteArray &);
	void build(ByteArray &);
}
#endif