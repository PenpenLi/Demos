#ifndef MOF_REQ_LEAVE_WORLD_SCENE_H
#define MOF_REQ_LEAVE_WORLD_SCENE_H

class req_leave_world_scene{
public:
	void req_leave_world_scene(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_leave_world_scene();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif