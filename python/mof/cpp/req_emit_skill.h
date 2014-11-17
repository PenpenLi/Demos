#ifndef MOF_REQ_EMIT_SKILL_H
#define MOF_REQ_EMIT_SKILL_H

class req_emit_skill{
public:
	void ~req_emit_skill();
	void decode(ByteArray &);
	void PacketName(void);
	void req_emit_skill(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif