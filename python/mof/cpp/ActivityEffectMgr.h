#ifndef MOF_ACTIVITYEFFECTMGR_H
#define MOF_ACTIVITYEFFECTMGR_H

class ActivityEffectMgr{
public:
	void changeActivityState(int,bool);
	void changeSynPvpOpenState(int,bool);
	void setSynPvpOpenIds(std::vector<int, std::allocator<int>> const&);
	void getOpenActivityIDs(std::vector<int, std::allocator<int>>);
	void changeGuildActivityState(int, bool);
	void setGuildActivityIds(std::vector<int, std::allocator<int>>);
	void setSynPvpOpenIds(std::vector<int,std::allocator<int>> const&);
	void changeActivityState(int, bool);
	void changeSynPvpOpenState(int,	bool);
	void getSynPvpOpenIds(void);
	void getOpenActivityVec(void);
	void isOpenActivity(int);
	void getGuildActivityIds(void);
	void changeGuildActivityState(int,bool);
	void setGuildActivityIds(std::vector<int,std::allocator<int>>);
	void getOpenActivityIDs(std::vector<int,std::allocator<int>>);
	void addActivityEffect(void);
}
#endif