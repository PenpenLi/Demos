#ifndef MOF_NOTIFY_WORLDCHAT_H
#define MOF_NOTIFY_WORLDCHAT_H

class notify_worldchat{
public:
	void ~notify_worldchat();
	void decode(ByteArray &);
	void PacketName(void);
	void notify_worldchat(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif