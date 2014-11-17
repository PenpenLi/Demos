#ifndef MOF_ACK_TREASURECOPY_GET_GUILDMANOR_AWARD_H
#define MOF_ACK_TREASURECOPY_GET_GUILDMANOR_AWARD_H

class ack_treasurecopy_get_guildmanor_award{
public:
	void ~ack_treasurecopy_get_guildmanor_award();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_treasurecopy_get_guildmanor_award(void);
	void encode(ByteArray &);
	void build(ByteArray &);
}
#endif