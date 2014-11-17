#ifndef MOF_REQ_GUILD_STOREUPDATE_H
#define MOF_REQ_GUILD_STOREUPDATE_H

class req_guild_storeUpdate{
public:
	void build(ByteArray &);
	void PacketName(void);
	void req_guild_storeUpdate(void);
	void decode(ByteArray &);
	void ~req_guild_storeUpdate();
	void encode(ByteArray &);
}
#endif