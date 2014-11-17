#ifndef MOF_NOTIFY_FLOPCARD_H
#define MOF_NOTIFY_FLOPCARD_H

class notify_flopcard{
public:
	void ~notify_flopcard();
	void notify_flopcard(void);
	void PacketName(void);
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif