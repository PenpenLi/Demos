#ifndef MOF_ACK_SYNC_STOP_H
#define MOF_ACK_SYNC_STOP_H

class ack_sync_stop{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_sync_stop(void);
	void ~ack_sync_stop();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif