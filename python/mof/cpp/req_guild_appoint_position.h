#ifndef MOF_REQ_GUILD_APPOINT_POSITION_H
#define MOF_REQ_GUILD_APPOINT_POSITION_H

class req_guild_appoint_position{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_guild_appoint_position();
	void req_guild_appoint_position(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif