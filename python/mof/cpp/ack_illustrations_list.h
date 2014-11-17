#ifndef MOF_ACK_ILLUSTRATIONS_LIST_H
#define MOF_ACK_ILLUSTRATIONS_LIST_H

class ack_illustrations_list{
public:
	void ~ack_illustrations_list();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_illustrations_list(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif