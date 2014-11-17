#ifndef MOF_REQ_GUILD_KICK_H
#define MOF_REQ_GUILD_KICK_H

class req_guild_kick{
public:
	void req_guild_kick(void);
	void decode(ByteArray &);
	void ~req_guild_kick();
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif