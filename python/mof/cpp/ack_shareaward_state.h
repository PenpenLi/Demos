#ifndef MOF_ACK_SHAREAWARD_STATE_H
#define MOF_ACK_SHAREAWARD_STATE_H

class ack_shareaward_state{
public:
	void ~ack_shareaward_state();
	void PacketName(void);
	void ack_shareaward_state(void);
	void decode(ByteArray &);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif