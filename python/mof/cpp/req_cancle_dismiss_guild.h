#ifndef MOF_REQ_CANCLE_DISMISS_GUILD_H
#define MOF_REQ_CANCLE_DISMISS_GUILD_H

class req_cancle_dismiss_guild{
public:
	void req_cancle_dismiss_guild(void);
	void ~req_cancle_dismiss_guild();
	void PacketName(void);
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif