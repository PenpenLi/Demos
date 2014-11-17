#ifndef MOF_ACK_GET_SCENE_THREADS_H
#define MOF_ACK_GET_SCENE_THREADS_H

class ack_get_scene_threads{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_get_scene_threads(void);
	void ~ack_get_scene_threads();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif