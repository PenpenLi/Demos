#ifndef MOF_REQ_PRIVATE_CHAT_HISTORY_H
#define MOF_REQ_PRIVATE_CHAT_HISTORY_H

class req_private_chat_history{
public:
	void ~req_private_chat_history();
	void decode(ByteArray &);
	void PacketName(void);
	void req_private_chat_history(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif