#ifndef MOF_REQ_APPLY_GUILD_H
#define MOF_REQ_APPLY_GUILD_H

class req_apply_guild{
public:
	void req_apply_guild(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_apply_guild();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif