#ifndef MOF_DICEGAMEMGR_H
#define MOF_DICEGAMEMGR_H

class DiceGameMgr{
public:
	void reqRollDice(void);
	void ackRollDice(int);
	void reqEnterDiceGame(void);
	void getDiceHistory(std::vector<obj_lotteryhistory, std::allocator<obj_lotteryhistory>> &);
	void getDiceHistory(std::vector<obj_lotteryhistory,std::allocator<obj_lotteryhistory>> &);
	void DiceGameMgr(void);
	void getFreeTimes(void);
	void ackEnterDiceGame(int, int, std::vector<obj_lotteryhistory, std::allocator<obj_lotteryhistory>>);
	void ackEnterDiceGame(int,int,std::vector<obj_lotteryhistory,std::allocator<obj_lotteryhistory>>);
}
#endif