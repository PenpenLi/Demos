#ifndef MOF_ACK_CLIENT_CHEAT_H
#define MOF_ACK_CLIENT_CHEAT_H

class ack_client_cheat{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_client_cheat();
	void ack_client_cheat(void);
	void encode(ByteArray &);
	void build(ByteArray &);
}
#endif