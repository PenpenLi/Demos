#ifndef MOF_REQ_ENTER_BOSS_SCENE_H
#define MOF_REQ_ENTER_BOSS_SCENE_H

class req_enter_boss_scene{
public:
	void ~req_enter_boss_scene();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray	&);
	void req_enter_boss_scene(void);
	void encode(ByteArray &);
}
#endif