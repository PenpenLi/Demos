#ifndef MOF_ACK_TRANSFER_GUILD_MASTER_H
#define MOF_ACK_TRANSFER_GUILD_MASTER_H

class ack_transfer_guild_master{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_transfer_guild_master(void);
	void ~ack_transfer_guild_master();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif