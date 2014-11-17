#ifndef MOF_ACK_ENTER_BOSS_SCENE_H
#define MOF_ACK_ENTER_BOSS_SCENE_H

class ack_enter_boss_scene{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_enter_boss_scene(void);
	void ~ack_enter_boss_scene();
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif