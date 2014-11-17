#ifndef MOF_TREASUREFIGHTMGR_H
#define MOF_TREASUREFIGHTMGR_H

class TreasureFightMgr{
public:
	void getRank(void);
	void getRoomInfoByCellIndex(int);
	void getIsServerResponse(void);
	void setGuildPoint(int);
	void findSceneName(int);
	void reqGetTreasureFightCopyData(int,int);
	void clearRoomData(void);
	void ~TreasureFightMgr();
	void ntyTreasureFightKillPlayer(notify_sync_treasurefight_kill_player);
	void reqQuickEnterTreasureFightCopy(void);
	void setIsServerResponse(int);
	void mainRoleDeadInTreasureFight(void);
	void notifyTreasureFightNewRoomOpen(notify_guild_new_treasurecopy const&);
	void ntyTreasureFightKillNpc(notify_sync_treasurefight_kill_npc);
	void sortRank(std::vector<obj_treasurecopy_rankdata, std::allocator<obj_treasurecopy_rankdata>>);
	void TreasureFightMgr(void);
	void reqGetTreasureFightCopyData(int, int);
	void sortRank(std::vector<obj_treasurecopy_rankdata,std::allocator<obj_treasurecopy_rankdata>>);
	void getRoomListSize(void);
	void getResurgenceTime(void);
	void getRankPoint(void);
	void getRank(void)const;
	void setResurgenceTime(int);
	void treasureFightGiveUp(void);
	void ackGetTreasureFightCopyData(ack_get_treasure_copy_data const&);
	void getIsGetall(void);
	void getCurPoint(void);
	void ackRankData(ack_sync_treasurefight_rank_data);
	void getIsServerResponse(void)const;
	void notifyTreasureFightInfoChange(notify_guild_treasurefight_data_change const&);
	void setRank(int);
	void notifyTreasureFightCopyDataChange(notify_guild_treasurecopy_change const&);
	void getGuildPoint(void)const;
	void getRoomInfoByIndex(int);
	void getGuildPoint(void);
	void quitOrDeadCallBack(void);
	void getRankName(void);
	void setIsGetall(int);
	void getResurgenceTime(void)const;
	void reqEnterTreasureFightActUI(void);
	void Init(void);
	void ackTreasurecopyGetFightingPoints(ack_treasurecopy_get_fighting_points);
	void findRoomImg(int);
	void setCurPoint(int);
	void findRoomPos(int);
	void getCurPoint(void)const;
	void updateRoomInfoByIndex(int, TreasureFightRoomInfo);
	void updateRoomInfoByIndex(int,TreasureFightRoomInfo);
	void enterTreasureFightScene(void);
	void reqEnterTreasureFightCopy(int);
	void ackEnterTreasureFightCopy(ack_enter_guild_treasurecopy const&);
	void ackQuickEnterTreasureFightCopy(ack_quick_enter_guild_treasurecopy const&);
	void reqLeaveTreasureFightActUI(void);
	void ackLeaveTreasureFightActUI(ack_leave_guild_treasure_activity const&);
	void ackEnterTreasureFightActUI(ack_enter_guild_treasurefight_activity const&);
	void getRoomListVecSize(void);
}
#endif