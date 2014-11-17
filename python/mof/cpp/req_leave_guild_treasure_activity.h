#ifndef MOF_REQ_LEAVE_GUILD_TREASURE_ACTIVITY_H
#define MOF_REQ_LEAVE_GUILD_TREASURE_ACTIVITY_H

class req_leave_guild_treasure_activity{
public:
	void ~req_leave_guild_treasure_activity();
	void decode(ByteArray &);
	void PacketName(void);
	void req_leave_guild_treasure_activity(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif