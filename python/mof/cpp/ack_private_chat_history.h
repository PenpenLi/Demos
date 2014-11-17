#ifndef MOF_ACK_PRIVATE_CHAT_HISTORY_H
#define MOF_ACK_PRIVATE_CHAT_HISTORY_H

class ack_private_chat_history{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_private_chat_history();
	void ack_private_chat_history(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif