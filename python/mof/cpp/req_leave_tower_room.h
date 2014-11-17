#ifndef MOF_REQ_LEAVE_TOWER_ROOM_H
#define MOF_REQ_LEAVE_TOWER_ROOM_H

class req_leave_tower_room{
public:
	void req_leave_tower_room(void);
	void ~req_leave_tower_room();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif