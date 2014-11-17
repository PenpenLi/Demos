#ifndef MOF_REQ_WORLDCHAT_H
#define MOF_REQ_WORLDCHAT_H

class req_worldchat{
public:
	void decode(ByteArray &);
	void req_worldchat(void);
	void PacketName(void);
	void ~req_worldchat();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif