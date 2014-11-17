#ifndef MOF_ACK_CANCLE_DISMISS_GUILD_H
#define MOF_ACK_CANCLE_DISMISS_GUILD_H

class ack_cancle_dismiss_guild{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_cancle_dismiss_guild();
	void ack_cancle_dismiss_guild(void);
	void encode(ByteArray &);
	void build(ByteArray &);
}
#endif