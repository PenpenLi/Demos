#ifndef MOF_REQ_GETTEAMCOPYDATA_H
#define MOF_REQ_GETTEAMCOPYDATA_H

class req_getTeamCopyData{
public:
	void ~req_getTeamCopyData();
	void decode(ByteArray	&);
	void PacketName(void);
	void encode(ByteArray	&);
	void req_getTeamCopyData(void);
	void build(ByteArray &);
}
#endif