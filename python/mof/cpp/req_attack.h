#ifndef MOF_REQ_ATTACK_H
#define MOF_REQ_ATTACK_H

class req_attack{
public:
	void ~req_attack();
	void decode(ByteArray &);
	void req_attack(void);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif