#ifndef MOF_NOTIFY_PLAYERBAG_H
#define MOF_NOTIFY_PLAYERBAG_H

class notify_playerbag{
public:
	void notify_playerbag(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_playerbag();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif