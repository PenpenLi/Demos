#ifndef MOF_REQ_SYNC_MOTION_H
#define MOF_REQ_SYNC_MOTION_H

class req_sync_motion{
public:
	void ~req_sync_motion();
	void decode(ByteArray &);
	void PacketName(void);
	void req_sync_motion(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif