#ifndef MOF_ACK_FAMESHALL_FAMESLIST_H
#define MOF_ACK_FAMESHALL_FAMESLIST_H

class ack_fameshall_fameslist{
public:
	void ack_fameshall_fameslist(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_fameshall_fameslist();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif