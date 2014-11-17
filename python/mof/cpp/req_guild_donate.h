#ifndef MOF_REQ_GUILD_DONATE_H
#define MOF_REQ_GUILD_DONATE_H

class req_guild_donate{
public:
	void req_guild_donate(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_guild_donate();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif