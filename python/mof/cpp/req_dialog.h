#ifndef MOF_REQ_DIALOG_H
#define MOF_REQ_DIALOG_H

class req_dialog{
public:
	void ~req_dialog();
	void decode(ByteArray &);
	void PacketName(void);
	void req_dialog(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif