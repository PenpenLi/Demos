#ifndef MOF_NOTIFY_WARDROBE_EXP_H
#define MOF_NOTIFY_WARDROBE_EXP_H

class notify_wardrobe_exp{
public:
	void decode(ByteArray	&);
	void build(ByteArray &);
	void PacketName(void);
	void encode(ByteArray	&);
	void ~notify_wardrobe_exp();
	void notify_wardrobe_exp(void);
}
#endif