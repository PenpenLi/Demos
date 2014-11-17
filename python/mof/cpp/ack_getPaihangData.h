#ifndef MOF_ACK_GETPAIHANGDATA_H
#define MOF_ACK_GETPAIHANGDATA_H

class ack_getPaihangData{
public:
	void ~ack_getPaihangData();
	void ack_getPaihangData(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif