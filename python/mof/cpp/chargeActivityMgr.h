#ifndef MOF_CHARGEACTIVITYMGR_H
#define MOF_CHARGEACTIVITYMGR_H

class chargeActivityMgr{
public:
	void addNewOnceGot(int);
	void getRmb(int,int);
	void bCanGetAward(int, int);
	void ackAddOnceChargeData(ack_re_recharge_status const&);
	void reqOnceChargeGetAward(int);
	void getOpenActivitysById(int);
	void getTime(int, int);
	void bHaveGotAward(int,	int);
	void ackAddOnceChargeGetAward(ack_re_recharge_get_award	const&);
	void ackAddChargeData(ack_acc_recharge_status const&);
	void firstChargeData(void);
	void addNewAdOnceGot(int);
	void ackAddChargeGetAward(ack_acc_recharge_get_award const&);
	void reqChargeActivityGetAward(int,int);
	void reqAddOnceChargeGetAward(int);
	void refreshChargeActivity(int);
	void reqChargeActivityGetAward(int, int);
	void getRmb(int, int);
	void addAddOnceDatasNew(std::vector<obj_recharge_info,std::allocator<obj_recharge_info>>);
	void ~chargeActivityMgr();
	void getAwardNumber(int, int);
	void reqChargeActivityData(int);
	void getTime(int,int);
	void chargeActivityMgr(void);
	void bCanGetAward(int,int);
	void reqAddConsumeGetAward(int);
	void initTypeInclude(void);
	void addOnceDatasNew(std::vector<obj_recharge_info, std::allocator<obj_recharge_info>>);
	void ackAddConsumeData(ack_acc_consume_status const&);
	void ackAddConsumeGetAward(ack_acc_consume_get_award const&);
	void addAddOnceDatasNew(std::vector<obj_recharge_info, std::allocator<obj_recharge_info>>);
	void reqAddChargeGetAward(int);
	void addOnceDatasNew(std::vector<obj_recharge_info,std::allocator<obj_recharge_info>>);
	void getAwardNumber(int,int);
	void ackOnceChargeGetAward(ack_once_recharge_get_award const&);
	void bHaveGotAward(int,int);
	void ackOnceChargeData(ack_once_recharge_status	const&);
}
#endif