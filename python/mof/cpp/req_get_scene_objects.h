#ifndef MOF_REQ_GET_SCENE_OBJECTS_H
#define MOF_REQ_GET_SCENE_OBJECTS_H

class req_get_scene_objects{
public:
	void req_get_scene_objects(void);
	void PacketName(void);
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~req_get_scene_objects();
}
#endif