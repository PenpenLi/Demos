#ifndef MOF_ACK_CANCEL_APPLY_GUILD_H
#define MOF_ACK_CANCEL_APPLY_GUILD_H

class ack_cancel_apply_guild{
public:
	void ack_cancel_apply_guild(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_cancel_apply_guild();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif