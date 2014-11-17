#ifndef MOF_REQ_CREATE_GUILD_H
#define MOF_REQ_CREATE_GUILD_H

class req_create_guild{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_create_guild(void);
	void ~req_create_guild();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif