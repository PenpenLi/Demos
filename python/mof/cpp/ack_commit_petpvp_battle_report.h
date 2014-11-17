#ifndef MOF_ACK_COMMIT_PETPVP_BATTLE_REPORT_H
#define MOF_ACK_COMMIT_PETPVP_BATTLE_REPORT_H

class ack_commit_petpvp_battle_report{
public:
	void ~ack_commit_petpvp_battle_report();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ack_commit_petpvp_battle_report(void);
}
#endif