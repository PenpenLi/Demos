#ifndef MOF_ACK_GUILD_BLESS_H
#define MOF_ACK_GUILD_BLESS_H

class ack_guild_bless{
public:
	void ack_guild_bless(void);
	void ~ack_guild_bless();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif