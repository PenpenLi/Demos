#ifndef MOF_ACK_GET_SCENE_OBJECTS_H
#define MOF_ACK_GET_SCENE_OBJECTS_H

class ack_get_scene_objects{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_get_scene_objects();
	void ack_get_scene_objects(ack_get_scene_objects const&);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ack_get_scene_objects(void);
}
#endif