#ifndef MOF_ACK_GUILD_LOG_H
#define MOF_ACK_GUILD_LOG_H

class ack_guild_log{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_guild_log();
	void ack_guild_log(void);
	void encode(ByteArray &);
	void build(ByteArray &);
}
#endif