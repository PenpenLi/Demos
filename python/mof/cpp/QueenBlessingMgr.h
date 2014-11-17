#ifndef MOF_QUEENBLESSINGMGR_H
#define MOF_QUEENBLESSINGMGR_H

class QueenBlessingMgr{
public:
	void reqQueenBlessingDatas(void);
	void ackGetQueenBlessingFat(void);
	void QueenBlessingMgr(void);
	void ackQueenBlessingDatas(int,std::string);
	void notifyHasGodBless(void);
	void getQueenBlessingList(void);
	void ~QueenBlessingMgr();
	void reqGetQueenBlessingFat(void);
	void ackQueenBlessingDatas(int, std::string);
}
#endif