#ifndef MOF_ACK_GETROLESAVE_H
#define MOF_ACK_GETROLESAVE_H

class ack_getrolesave{
public:
	void ~ack_getrolesave();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_getrolesave(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif