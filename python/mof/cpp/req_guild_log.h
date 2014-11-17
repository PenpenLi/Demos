#ifndef MOF_REQ_GUILD_LOG_H
#define MOF_REQ_GUILD_LOG_H

class req_guild_log{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_guild_log();
	void req_guild_log(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif