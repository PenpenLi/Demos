#ifndef MOF_ACK_ENTER_WORLD_SCENE_H
#define MOF_ACK_ENTER_WORLD_SCENE_H

class ack_enter_world_scene{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void encode(ByteArray &);
	void ack_enter_world_scene(void);
	void build(ByteArray &);
	void ~ack_enter_world_scene();
}
#endif