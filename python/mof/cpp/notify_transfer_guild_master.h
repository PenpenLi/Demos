#ifndef MOF_NOTIFY_TRANSFER_GUILD_MASTER_H
#define MOF_NOTIFY_TRANSFER_GUILD_MASTER_H

class notify_transfer_guild_master{
public:
	void notify_transfer_guild_master(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
	void ~notify_transfer_guild_master();
}
#endif