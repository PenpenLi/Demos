#ifndef MOF_ACK_GETPETPAIHANGDATA_H
#define MOF_ACK_GETPETPAIHANGDATA_H

class ack_getPetPaihangData{
public:
	void ~ack_getPetPaihangData();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_getPetPaihangData(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif