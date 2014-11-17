#ifndef MOF_REQ_SYNC_STOP_H
#define MOF_REQ_SYNC_STOP_H

class req_sync_stop{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_sync_stop(void);
	void ~req_sync_stop();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif