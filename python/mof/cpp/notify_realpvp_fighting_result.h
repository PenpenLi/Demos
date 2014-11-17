#ifndef MOF_NOTIFY_REALPVP_FIGHTING_RESULT_H
#define MOF_NOTIFY_REALPVP_FIGHTING_RESULT_H

class notify_realpvp_fighting_result{
public:
	void ~notify_realpvp_fighting_result();
	void decode(ByteArray &);
	void notify_realpvp_fighting_result(void);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif