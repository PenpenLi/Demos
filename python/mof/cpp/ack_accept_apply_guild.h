#ifndef MOF_ACK_ACCEPT_APPLY_GUILD_H
#define MOF_ACK_ACCEPT_APPLY_GUILD_H

class ack_accept_apply_guild{
public:
	void ~ack_accept_apply_guild();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_accept_apply_guild(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif