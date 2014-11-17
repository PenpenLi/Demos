#ifndef MOF_ACK_LEAVE_TOWER_ROOM_H
#define MOF_ACK_LEAVE_TOWER_ROOM_H

class ack_leave_tower_room{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_leave_tower_room();
	void ack_leave_tower_room(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif