#ifndef MOF_SYN_HURTBOSS_RANK_H
#define MOF_SYN_HURTBOSS_RANK_H

class syn_hurtboss_rank{
public:
	void syn_hurtboss_rank(void);
	void decode(ByteArray &);
	void ~syn_hurtboss_rank();
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif