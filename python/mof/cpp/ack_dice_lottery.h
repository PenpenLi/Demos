#ifndef MOF_ACK_DICE_LOTTERY_H
#define MOF_ACK_DICE_LOTTERY_H

class ack_dice_lottery{
public:
	void ack_dice_lottery(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_dice_lottery();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif