#ifndef MOF_REQ_BUY_FAT_H
#define MOF_REQ_BUY_FAT_H

class req_buy_fat{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void encode(ByteArray	&);
	void ~req_buy_fat();
	void req_buy_fat(void);
	void build(ByteArray &);
}
#endif