#ifndef MOF_ACK_USE_ALLITEMS_H
#define MOF_ACK_USE_ALLITEMS_H

class ack_use_allitems{
public:
	void ack_use_allitems(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_use_allitems();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif