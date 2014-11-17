#ifndef MOF_NOTIFY_PRIVATECHAT_H
#define MOF_NOTIFY_PRIVATECHAT_H

class notify_privatechat{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void notify_privatechat(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~notify_privatechat();
}
#endif