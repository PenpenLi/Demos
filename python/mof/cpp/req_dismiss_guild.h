#ifndef MOF_REQ_DISMISS_GUILD_H
#define MOF_REQ_DISMISS_GUILD_H

class req_dismiss_guild{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_dismiss_guild();
	void req_dismiss_guild(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif