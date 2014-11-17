#ifndef MOF_ACK_ENTER_ELITECOPY_H
#define MOF_ACK_ENTER_ELITECOPY_H

class ack_enter_elitecopy{
public:
	void ack_enter_elitecopy(void);
	void decode(ByteArray	&);
	void ~ack_enter_elitecopy();
	void PacketName(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif