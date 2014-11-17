#ifndef MOF_REQ_LEAVE_BOSS_SCENE_H
#define MOF_REQ_LEAVE_BOSS_SCENE_H

class req_leave_boss_scene{
public:
	void ~req_leave_boss_scene();
	void decode(ByteArray &);
	void PacketName(void);
	void req_leave_boss_scene(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif