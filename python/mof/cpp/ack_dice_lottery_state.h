#ifndef MOF_ACK_DICE_LOTTERY_STATE_H
#define MOF_ACK_DICE_LOTTERY_STATE_H

class ack_dice_lottery_state{
public:
	void ~ack_dice_lottery_state();
	void decode(ByteArray &);
	void ack_dice_lottery_state(void);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif