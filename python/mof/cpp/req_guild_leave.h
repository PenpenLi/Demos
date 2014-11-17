#ifndef MOF_REQ_GUILD_LEAVE_H
#define MOF_REQ_GUILD_LEAVE_H

class req_guild_leave{
public:
	void decode(ByteArray &);
	void req_guild_leave(void);
	void PacketName(void);
	void ~req_guild_leave();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif