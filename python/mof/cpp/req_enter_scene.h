#ifndef MOF_REQ_ENTER_SCENE_H
#define MOF_REQ_ENTER_SCENE_H

class req_enter_scene{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_enter_scene();
	void req_enter_scene(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif