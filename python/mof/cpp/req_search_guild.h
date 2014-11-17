#ifndef MOF_REQ_SEARCH_GUILD_H
#define MOF_REQ_SEARCH_GUILD_H

class req_search_guild{
public:
	void req_search_guild(void);
	void decode(ByteArray &);
	void ~req_search_guild();
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif