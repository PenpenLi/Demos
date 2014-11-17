#ifndef MOF_REQ_TOTEM_IMMOLATION_H
#define MOF_REQ_TOTEM_IMMOLATION_H

class req_totem_immolation{
public:
	void ~req_totem_immolation();
	void req_totem_immolation(void);
	void PacketName(void);
	void decode(ByteArray &);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif