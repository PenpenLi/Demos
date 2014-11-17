#ifndef MOF_NOTIFY_WORLDPLAYER_LEAVE_SCENE_H
#define MOF_NOTIFY_WORLDPLAYER_LEAVE_SCENE_H

class notify_worldplayer_leave_scene{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_worldplayer_leave_scene();
	void notify_worldplayer_leave_scene(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif