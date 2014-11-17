#ifndef MOF_ACK_GUILD_STOREUPDATE_H
#define MOF_ACK_GUILD_STOREUPDATE_H

class ack_guild_storeUpdate{
public:
	void decode(ByteArray &);
	void ~ack_guild_storeUpdate();
	void PacketName(void);
	void ack_guild_storeUpdate(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif