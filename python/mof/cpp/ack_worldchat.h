#ifndef MOF_ACK_WORLDCHAT_H
#define MOF_ACK_WORLDCHAT_H

class ack_worldchat{
public:
	void ack_worldchat(void);
	void ~ack_worldchat();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif