#ifndef MOF_ACK_GUILD_KICK_H
#define MOF_ACK_GUILD_KICK_H

class ack_guild_kick{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_guild_kick(void);
	void ~ack_guild_kick();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif