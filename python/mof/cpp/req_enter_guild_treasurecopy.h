#ifndef MOF_REQ_ENTER_GUILD_TREASURECOPY_H
#define MOF_REQ_ENTER_GUILD_TREASURECOPY_H

class req_enter_guild_treasurecopy{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_enter_guild_treasurecopy(void);
	void ~req_enter_guild_treasurecopy();
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif