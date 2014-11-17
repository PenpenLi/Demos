#ifndef MOF_ACK_LEAVE_GUILD_TREASURE_ACTIVITY_H
#define MOF_ACK_LEAVE_GUILD_TREASURE_ACTIVITY_H

class ack_leave_guild_treasure_activity{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_leave_guild_treasure_activity(void);
	void ~ack_leave_guild_treasure_activity();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif