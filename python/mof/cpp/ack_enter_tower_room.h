#ifndef MOF_ACK_ENTER_TOWER_ROOM_H
#define MOF_ACK_ENTER_TOWER_ROOM_H

class ack_enter_tower_room{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_enter_tower_room();
	void build(ByteArray	&);
	void ack_enter_tower_room(void);
	void encode(ByteArray &);
}
#endif