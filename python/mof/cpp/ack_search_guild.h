#ifndef MOF_ACK_SEARCH_GUILD_H
#define MOF_ACK_SEARCH_GUILD_H

class ack_search_guild{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_search_guild(void);
	void ~ack_search_guild();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif