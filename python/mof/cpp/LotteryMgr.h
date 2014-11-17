#ifndef MOF_LOTTERYMGR_H
#define MOF_LOTTERYMGR_H

class LotteryMgr{
public:
	void getLotteryItemDataByIndex(int);
	void reqLotteryData(void);
	void getLotteryItemSize(void);
	void ackLotteryData(std::vector<obj_lotteryhistory, std::allocator<obj_lotteryhistory>>);
	void ~LotteryMgr();
	void LotteryMgr(void);
	void ackLotteryData(std::vector<obj_lotteryhistory,std::allocator<obj_lotteryhistory>>);
	void clearData(void);
}
#endif