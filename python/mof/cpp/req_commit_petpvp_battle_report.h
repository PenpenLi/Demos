#ifndef MOF_REQ_COMMIT_PETPVP_BATTLE_REPORT_H
#define MOF_REQ_COMMIT_PETPVP_BATTLE_REPORT_H

class req_commit_petpvp_battle_report{
public:
	void req_commit_petpvp_battle_report(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_commit_petpvp_battle_report();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif