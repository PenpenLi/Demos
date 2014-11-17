#ifndef MOF_REQ_GUILD_CHAT_H
#define MOF_REQ_GUILD_CHAT_H

class req_guild_chat{
public:
	void req_guild_chat(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_guild_chat();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif