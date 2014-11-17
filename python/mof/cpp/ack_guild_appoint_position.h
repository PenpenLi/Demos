#ifndef MOF_ACK_GUILD_APPOINT_POSITION_H
#define MOF_ACK_GUILD_APPOINT_POSITION_H

class ack_guild_appoint_position{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_guild_appoint_position();
	void ack_guild_appoint_position(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif