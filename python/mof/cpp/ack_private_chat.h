#ifndef MOF_ACK_PRIVATE_CHAT_H
#define MOF_ACK_PRIVATE_CHAT_H

class ack_private_chat{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_private_chat(void);
	void ~ack_private_chat();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif