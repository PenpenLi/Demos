#ifndef MOF_RANKMGR_H
#define MOF_RANKMGR_H

class RankMgr{
public:
	void getQualityColorByIndex(int);
	void getDataSizeByType(SortType);
	void getFightDataByIndex(int);
	void getLevelDataByIndex(int);
	void ackPersonRankDatas(SortType,	std::vector<obj_paihangdata, std::allocator<obj_paihangdata>>, int, int, int, int);
	void clearRankData(SortType);
	void RankMgr(void);
	void getArenaDataByIndex(int);
	void reqRankDatas(SortType,int,int);
	void ackPersonRankDatas(SortType,std::vector<obj_paihangdata,std::allocator<obj_paihangdata>>,int,int,int,int);
	void reqRankDatas(SortType, int, int);
	void ~RankMgr();
	void getPetDataByIndex(int);
	void ackPetRankDatas(std::vector<obj_Petpaihangdata, std::allocator<obj_Petpaihangdata>>,	int, int, int);
	void ackPetRankDatas(std::vector<obj_Petpaihangdata,std::allocator<obj_Petpaihangdata>>,int,int,int);
}
#endif