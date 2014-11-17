#ifndef MOF_REQ_TREASURECOPY_GET_FIGHTING_POINTS_H
#define MOF_REQ_TREASURECOPY_GET_FIGHTING_POINTS_H

class req_treasurecopy_get_fighting_points{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_treasurecopy_get_fighting_points(void);
	void build(ByteArray	&);
	void ~req_treasurecopy_get_fighting_points();
	void encode(ByteArray &);
}
#endif