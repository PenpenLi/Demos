#ifndef MOF_NOTIFY_WORLDNPC_ENTER_SCENE_H
#define MOF_NOTIFY_WORLDNPC_ENTER_SCENE_H

class notify_worldnpc_enter_scene{
public:
	void decode(ByteArray	&);
	void notify_worldnpc_enter_scene(void);
	void PacketName(void);
	void ~notify_worldnpc_enter_scene();
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif