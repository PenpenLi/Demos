#ifndef MOF_ACK_PAST_GUILD_CHAT_H
#define MOF_ACK_PAST_GUILD_CHAT_H

class ack_past_guild_chat{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void ~ack_past_guild_chat();
	void encode(ByteArray	&);
	void ack_past_guild_chat(void);
	void build(ByteArray &);
}
#endif