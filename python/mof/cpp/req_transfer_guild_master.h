#ifndef MOF_REQ_TRANSFER_GUILD_MASTER_H
#define MOF_REQ_TRANSFER_GUILD_MASTER_H

class req_transfer_guild_master{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_transfer_guild_master();
	void req_transfer_guild_master(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif