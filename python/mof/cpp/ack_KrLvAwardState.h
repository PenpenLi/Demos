#ifndef MOF_ACK_KRLVAWARDSTATE_H
#define MOF_ACK_KRLVAWARDSTATE_H

class ack_KrLvAwardState{
public:
	void ~ack_KrLvAwardState();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_KrLvAwardState(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif