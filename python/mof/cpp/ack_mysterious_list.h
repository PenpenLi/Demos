#ifndef MOF_ACK_MYSTERIOUS_LIST_H
#define MOF_ACK_MYSTERIOUS_LIST_H

class ack_mysterious_list{
public:
	void ack_mysterious_list(void);
	void decode(ByteArray	&);
	void build(ByteArray &);
	void PacketName(void);
	void encode(ByteArray	&);
	void ~ack_mysterious_list();
}
#endif