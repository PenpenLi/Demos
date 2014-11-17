#ifndef MOF_ACK_DISMISS_GUILD_H
#define MOF_ACK_DISMISS_GUILD_H

class ack_dismiss_guild{
public:
	void ack_dismiss_guild(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~ack_dismiss_guild();
}
#endif