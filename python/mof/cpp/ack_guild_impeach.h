#ifndef MOF_ACK_GUILD_IMPEACH_H
#define MOF_ACK_GUILD_IMPEACH_H

class ack_guild_impeach{
public:
	void ~ack_guild_impeach();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ack_guild_impeach(void);
}
#endif