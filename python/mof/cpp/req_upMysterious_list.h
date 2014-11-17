#ifndef MOF_REQ_UPMYSTERIOUS_LIST_H
#define MOF_REQ_UPMYSTERIOUS_LIST_H

class req_upMysterious_list{
public:
	void ~req_upMysterious_list();
	void decode(ByteArray &);
	void PacketName(void);
	void encode(ByteArray &);
	void build(ByteArray &);
	void req_upMysterious_list(void);
}
#endif