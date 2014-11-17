#ifndef MOF_REQ_CLIENT_HEART_BEAT_H
#define MOF_REQ_CLIENT_HEART_BEAT_H

class req_client_heart_beat{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_client_heart_beat(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~req_client_heart_beat();
}
#endif