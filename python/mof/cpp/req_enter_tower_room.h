#ifndef MOF_REQ_ENTER_TOWER_ROOM_H
#define MOF_REQ_ENTER_TOWER_ROOM_H

class req_enter_tower_room{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_enter_tower_room(void);
	void build(ByteArray	&);
	void ~req_enter_tower_room();
	void encode(ByteArray &);
}
#endif