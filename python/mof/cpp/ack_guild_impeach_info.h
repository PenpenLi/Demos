#ifndef MOF_ACK_GUILD_IMPEACH_INFO_H
#define MOF_ACK_GUILD_IMPEACH_INFO_H

class ack_guild_impeach_info{
public:
	void ack_guild_impeach_info(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_guild_impeach_info();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif