#ifndef MOF_REQ_PRIVATECHAT_H
#define MOF_REQ_PRIVATECHAT_H

class req_privatechat{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void encode(ByteArray &);
	void req_privatechat(void);
	void build(ByteArray &);
	void ~req_privatechat();
}
#endif