#ifndef MOF_ACK_ENTER_GUILD_TREASURECOPY_H
#define MOF_ACK_ENTER_GUILD_TREASURECOPY_H

class ack_enter_guild_treasurecopy{
public:
	void build(ByteArray	&);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_enter_guild_treasurecopy();
	void ack_enter_guild_treasurecopy(void);
	void encode(ByteArray &);
}
#endif