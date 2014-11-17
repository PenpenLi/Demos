#ifndef MOF_REQ_TREASURECOPY_GET_MANORS_H
#define MOF_REQ_TREASURECOPY_GET_MANORS_H

class req_treasurecopy_get_manors{
public:
	void decode(ByteArray	&);
	void ~req_treasurecopy_get_manors();
	void PacketName(void);
	void req_treasurecopy_get_manors(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif