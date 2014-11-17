#ifndef MOF_REQ_DICE_LOTTERY_H
#define MOF_REQ_DICE_LOTTERY_H

class req_dice_lottery{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_dice_lottery();
	void req_dice_lottery(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif