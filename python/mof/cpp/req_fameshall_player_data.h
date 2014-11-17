#ifndef MOF_REQ_FAMESHALL_PLAYER_DATA_H
#define MOF_REQ_FAMESHALL_PLAYER_DATA_H

class req_fameshall_player_data{
public:
	void ~req_fameshall_player_data();
	void decode(ByteArray &);
	void req_fameshall_player_data(void);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif