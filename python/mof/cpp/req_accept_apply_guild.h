#ifndef MOF_REQ_ACCEPT_APPLY_GUILD_H
#define MOF_REQ_ACCEPT_APPLY_GUILD_H

class req_accept_apply_guild{
public:
	void ~req_accept_apply_guild();
	void req_accept_apply_guild(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif