#ifndef MOF_REQ_PAST_GUILD_CHAT_H
#define MOF_REQ_PAST_GUILD_CHAT_H

class req_past_guild_chat{
public:
	void ~req_past_guild_chat();
	void decode(ByteArray	&);
	void PacketName(void);
	void encode(ByteArray	&);
	void req_past_guild_chat(void);
	void build(ByteArray &);
}
#endif