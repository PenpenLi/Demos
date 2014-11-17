#ifndef MOF_ACK_SYNC_MOTION_H
#define MOF_ACK_SYNC_MOTION_H

class ack_sync_motion{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ack_sync_motion(void);
	void ~ack_sync_motion();
}
#endif