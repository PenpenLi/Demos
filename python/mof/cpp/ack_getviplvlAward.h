#ifndef MOF_ACK_GETVIPLVLAWARD_H
#define MOF_ACK_GETVIPLVLAWARD_H

class ack_getviplvlAward{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_getviplvlAward();
	void build(ByteArray &);
	void encode(ByteArray &);
	void ack_getviplvlAward(void);
}
#endif