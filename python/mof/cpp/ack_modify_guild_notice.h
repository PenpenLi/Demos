#ifndef MOF_ACK_MODIFY_GUILD_NOTICE_H
#define MOF_ACK_MODIFY_GUILD_NOTICE_H

class ack_modify_guild_notice{
public:
	void ~ack_modify_guild_notice();
	void decode(ByteArray &);
	void PacketName(void);
	void encode(ByteArray &);
	void build(ByteArray &);
	void ack_modify_guild_notice(void);
}
#endif