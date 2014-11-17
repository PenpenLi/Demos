#ifndef MOF_REQ_GETVIPLVLAWARD_H
#define MOF_REQ_GETVIPLVLAWARD_H

class req_getviplvlAward{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_getviplvlAward();
	void req_getviplvlAward(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif