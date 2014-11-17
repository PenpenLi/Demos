#ifndef MOF_ACTIVITYCFG_H
#define MOF_ACTIVITYCFG_H

class ActivityCfg{
public:
	void getSynPvpData(int);
	void getMaxActivity(void);
	void getActivityData(int);
	void getGuildAllDataBySort(std::vector<int, std::allocator<int>>);
	void getGuildMaxActivity(void);
	void getGuildTreasureFightOpenDays(void);
	void getGuildAllDataBySort(std::vector<int,std::allocator<int>>);
	void load(std::string);
	void getAllDataBySort(std::vector<int,std::allocator<int>>,int);
	void getAllDataBySort(std::vector<int, std::allocator<int>>, int);
	void getGuildActivityTotalId(void);
	void getGuildActivityData(int);
}
#endif