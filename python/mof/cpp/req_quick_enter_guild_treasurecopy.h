#ifndef MOF_REQ_QUICK_ENTER_GUILD_TREASURECOPY_H
#define MOF_REQ_QUICK_ENTER_GUILD_TREASURECOPY_H

class req_quick_enter_guild_treasurecopy{
public:
	void decode(ByteArray &);
	void req_quick_enter_guild_treasurecopy(void);
	void PacketName(void);
	void ~req_quick_enter_guild_treasurecopy();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif