#ifndef MOF_MONTHCARDMGR_H
#define MOF_MONTHCARDMGR_H

class monthCardMgr{
public:
	void ackCollectCardAwards(ack_month_recharge_get_award const&);
	void getLastCurCollectIndex(void);
	void removeCurIndex(int);
	void getCollectDataByIndex(int);
	void getCurIndexVec(int);
	void ackMonthCardDatas(ack_month_recharge_status const&);
	void reqCollectCardAwards(int);
	void monthCardMgr(void);
	void reqMonthCardDatas(void);
}
#endif