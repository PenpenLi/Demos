#ifndef MOF_ACK_GETTEAMCOPYDATA_H
#define MOF_ACK_GETTEAMCOPYDATA_H

class ack_getTeamCopyData{
public:
	void ~ack_getTeamCopyData();
	void decode(ByteArray	&);
	void build(ByteArray &);
	void PacketName(void);
	void encode(ByteArray	&);
	void ack_getTeamCopyData(void);
}
#endif