#ifndef MOF_ACK_PVPRESULT_H
#define MOF_ACK_PVPRESULT_H

class ack_PvpResult{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_PvpResult();
	void ack_PvpResult(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif