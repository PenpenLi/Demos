#ifndef MOF_ACK_GET_PETIDLIST_COPY_H
#define MOF_ACK_GET_PETIDLIST_COPY_H

class ack_get_petidlist_copy{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_get_petidlist_copy();
	void ack_get_petidlist_copy(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif