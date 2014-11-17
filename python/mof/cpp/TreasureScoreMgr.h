#ifndef MOF_TREASURESCOREMGR_H
#define MOF_TREASURESCOREMGR_H

class TreasureScoreMgr{
public:
	void TreasureScoreMgr(void);
	void ntyTreasureScoreData(notify_treasurecopy_activity_result const&);
	void ~TreasureScoreMgr();
	void getTreasureScoreVec(void);
}
#endif