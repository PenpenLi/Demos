#ifndef MOF_ACK_BEGINTEAMCOPY_H
#define MOF_ACK_BEGINTEAMCOPY_H

class ack_beginTeamCopy{
public:
	void ~ack_beginTeamCopy();
	void ack_beginTeamCopy(void);
	void PacketName(void);
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif