#ifndef MOF_REQ_TOWER_ROOM_NEXT_WAVE_H
#define MOF_REQ_TOWER_ROOM_NEXT_WAVE_H

class req_tower_room_next_wave{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_tower_room_next_wave(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~req_tower_room_next_wave();
}
#endif