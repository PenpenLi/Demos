#ifndef MOF_REQ_TREASURECOPY_GET_GUILDMANOR_AWARD_H
#define MOF_REQ_TREASURECOPY_GET_GUILDMANOR_AWARD_H

class req_treasurecopy_get_guildmanor_award{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_treasurecopy_get_guildmanor_award();
	void req_treasurecopy_get_guildmanor_award(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif