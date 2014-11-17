#ifndef MOF_ACK_QUICK_ENTER_GUILD_TREASURECOPY_H
#define MOF_ACK_QUICK_ENTER_GUILD_TREASURECOPY_H

class ack_quick_enter_guild_treasurecopy{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_quick_enter_guild_treasurecopy(void);
	void ~ack_quick_enter_guild_treasurecopy();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif