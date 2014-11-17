#ifndef MOF_ACK_WARDROBE_INFO_H
#define MOF_ACK_WARDROBE_INFO_H

class ack_wardrobe_info{
public:
	void ~ack_wardrobe_info();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_wardrobe_info(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif