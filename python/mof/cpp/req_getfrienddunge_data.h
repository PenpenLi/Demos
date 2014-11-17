#ifndef MOF_REQ_GETFRIENDDUNGE_DATA_H
#define MOF_REQ_GETFRIENDDUNGE_DATA_H

class req_getfrienddunge_data{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_getfrienddunge_data();
	void req_getfrienddunge_data(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif