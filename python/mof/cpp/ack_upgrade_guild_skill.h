#ifndef MOF_ACK_UPGRADE_GUILD_SKILL_H
#define MOF_ACK_UPGRADE_GUILD_SKILL_H

class ack_upgrade_guild_skill{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_upgrade_guild_skill();
	void ack_upgrade_guild_skill(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif