#ifndef MOF_ACK_PLAYERBAG_H
#define MOF_ACK_PLAYERBAG_H

class ack_playerbag{
public:
	void ~ack_playerbag();
	void decode(ByteArray &);
	void PacketName(void);
	void encode(ByteArray &);
	void build(ByteArray &);
	void ack_playerbag(void);
}
#endif