#ifndef MOF_NOTIFY_OBJECTS_POS_H
#define MOF_NOTIFY_OBJECTS_POS_H

class notify_objects_pos{
public:
	void notify_objects_pos(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~notify_objects_pos();
}
#endif