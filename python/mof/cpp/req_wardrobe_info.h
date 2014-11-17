#ifndef MOF_REQ_WARDROBE_INFO_H
#define MOF_REQ_WARDROBE_INFO_H

class req_wardrobe_info{
public:
	void ~req_wardrobe_info();
	void decode(ByteArray &);
	void PacketName(void);
	void req_wardrobe_info(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif