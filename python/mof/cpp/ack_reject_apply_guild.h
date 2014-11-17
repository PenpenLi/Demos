#ifndef MOF_ACK_REJECT_APPLY_GUILD_H
#define MOF_ACK_REJECT_APPLY_GUILD_H

class ack_reject_apply_guild{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_reject_apply_guild();
	void ack_reject_apply_guild(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif