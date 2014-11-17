#ifndef MOF_ACK_EMIT_SKILL_H
#define MOF_ACK_EMIT_SKILL_H

class ack_emit_skill{
public:
	void ~ack_emit_skill();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_emit_skill(void);
	void encode(ByteArray &);
	void build(ByteArray &);
}
#endif