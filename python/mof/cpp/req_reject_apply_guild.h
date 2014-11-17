#ifndef MOF_REQ_REJECT_APPLY_GUILD_H
#define MOF_REQ_REJECT_APPLY_GUILD_H

class req_reject_apply_guild{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_reject_apply_guild();
	void req_reject_apply_guild(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif