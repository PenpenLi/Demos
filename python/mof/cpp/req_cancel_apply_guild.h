#ifndef MOF_REQ_CANCEL_APPLY_GUILD_H
#define MOF_REQ_CANCEL_APPLY_GUILD_H

class req_cancel_apply_guild{
public:
	void ~req_cancel_apply_guild();
	void decode(ByteArray &);
	void PacketName(void);
	void req_cancel_apply_guild(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif