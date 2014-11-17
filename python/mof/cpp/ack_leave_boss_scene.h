#ifndef MOF_ACK_LEAVE_BOSS_SCENE_H
#define MOF_ACK_LEAVE_BOSS_SCENE_H

class ack_leave_boss_scene{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray	&);
	void ack_leave_boss_scene(void);
	void ~ack_leave_boss_scene();
	void encode(ByteArray &);
}
#endif