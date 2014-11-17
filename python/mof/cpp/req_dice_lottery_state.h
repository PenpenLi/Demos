#ifndef MOF_REQ_DICE_LOTTERY_STATE_H
#define MOF_REQ_DICE_LOTTERY_STATE_H

class req_dice_lottery_state{
public:
	void ~req_dice_lottery_state();
	void decode(ByteArray &);
	void PacketName(void);
	void req_dice_lottery_state(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif