#ifndef MOF_REQ_BEGINTEAMCOPY_H
#define MOF_REQ_BEGINTEAMCOPY_H

class req_beginTeamCopy{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_beginTeamCopy(void);
	void ~req_beginTeamCopy();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif