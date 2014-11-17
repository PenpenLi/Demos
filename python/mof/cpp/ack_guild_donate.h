#ifndef MOF_ACK_GUILD_DONATE_H
#define MOF_ACK_GUILD_DONATE_H

class ack_guild_donate{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_guild_donate(void);
	void ~ack_guild_donate();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif