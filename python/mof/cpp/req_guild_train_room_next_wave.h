#ifndef MOF_REQ_GUILD_TRAIN_ROOM_NEXT_WAVE_H
#define MOF_REQ_GUILD_TRAIN_ROOM_NEXT_WAVE_H

class req_guild_train_room_next_wave{
public:
	void req_guild_train_room_next_wave(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_guild_train_room_next_wave();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif