#ifndef MOF_REQ_UPGRADE_GUILD_SKILL_H
#define MOF_REQ_UPGRADE_GUILD_SKILL_H

class req_upgrade_guild_skill{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_upgrade_guild_skill(void);
	void ~req_upgrade_guild_skill();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif