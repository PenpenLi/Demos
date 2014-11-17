#ifndef MOF_TREASUREMANORSMGR_H
#define MOF_TREASUREMANORSMGR_H

class TreasureManorsMgr{
public:
	void TreasureManorsMgr(void);
	void findManorDataIndex(int);
	void ~TreasureManorsMgr();
	void reqTreasureAwardComfort(int);
	void ackTreasureAwardComfort(ack_treasurecopy_get_guildmanor_award const&);
	void setManorCanAwardState(int,	int);
	void reqTreasureManorData(void);
	void isInManorOpenDays(int);
	void findManorDataByOpenDays(int);
	void setTownType(void);
	void ackTreasureManorData(ack_treasurecopy_get_manors const&);
	void parseAwardStr(std::string);
	void setManorCanAwardState(int,int);
	void findManorCanAwardByIndex(int);
}
#endif