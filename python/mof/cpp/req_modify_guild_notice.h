#ifndef MOF_REQ_MODIFY_GUILD_NOTICE_H
#define MOF_REQ_MODIFY_GUILD_NOTICE_H

class req_modify_guild_notice{
public:
	void req_modify_guild_notice(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_modify_guild_notice();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif