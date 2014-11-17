#ifndef MOF_ACK_FAMESHALL_BEGINBATTLE_H
#define MOF_ACK_FAMESHALL_BEGINBATTLE_H

class ack_fameshall_beginbattle{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_fameshall_beginbattle();
	void ack_fameshall_beginbattle(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif