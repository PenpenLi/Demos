#ifndef MOF_ACK_LEAVE_WORLD_SCENE_H
#define MOF_ACK_LEAVE_WORLD_SCENE_H

class ack_leave_world_scene{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_leave_world_scene(void);
	void ~ack_leave_world_scene();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif