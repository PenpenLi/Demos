#ifndef MOF_SYN_EXP_H
#define MOF_SYN_EXP_H

class syn_exp{
public:
	void syn_exp(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~syn_exp();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif