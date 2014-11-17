#ifndef MOF_REQ_HONOR_CANCEL_H
#define MOF_REQ_HONOR_CANCEL_H

class req_honor_cancel{
public:
	void req_honor_cancel(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_honor_cancel();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif