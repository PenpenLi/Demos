#ifndef MOF_ACK_FAMESHALL_PLAYER_DATA_H
#define MOF_ACK_FAMESHALL_PLAYER_DATA_H

class ack_fameshall_player_data{
public:
	void ack_fameshall_player_data(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_fameshall_player_data();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif