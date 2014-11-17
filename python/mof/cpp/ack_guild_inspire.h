#ifndef MOF_ACK_GUILD_INSPIRE_H
#define MOF_ACK_GUILD_INSPIRE_H

class ack_guild_inspire{
public:
	void ack_guild_inspire(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_guild_inspire();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif