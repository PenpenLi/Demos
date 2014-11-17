#ifndef MOF_REQ_GET_SCENE_THREADS_H
#define MOF_REQ_GET_SCENE_THREADS_H

class req_get_scene_threads{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_get_scene_threads(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~req_get_scene_threads();
}
#endif