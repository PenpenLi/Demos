#ifndef MOF_CTALKINGGAME_H
#define MOF_CTALKINGGAME_H

class CTalkingGame{
public:
	void composeItem(int,std::string,std::string,std::string,std::string);
	void promoteEquip(int, std::string, std::string, int, std::string);
	void onTeamCopy(int,	std::string, std::string, std::string, int, std::string, bool);
	void onReqCharge(std::string, std::string, int, int);
	void onFinishCharge(std::string);
	void getAStone(int,std::string,std::string,int);
	void getAStone(int, std::string, std::string, int);
	void setAccountLvl(int);
	void useDiamond(std::string,	int, int);
	void failQuest(std::string, std::string);
	void getDiamond(int,std::string);
	void onEnterGame(int);
	void onReqCharge(std::string,std::string,int,int);
	void failQuest(std::string,std::string);
	void onPvp(int,std::string,std::string,std::string,bool);
	void roleDead(int, std::string, std::string,	std::string);
	void onCtreateRole(int, std::string,	int, int, int, std::string);
	void onEliteCopy(int, std::string, std::string, std::string,	bool);
	void getAPetEgg(int,std::string,std::string,int);
	void onCtreateRole(int,std::string,int,int,int,std::string);
	void useAPetEgg(int,	std::string, std::string, int);
	void finishQuest(std::string);
	void attachEquip(int,std::string,std::string,std::string,int,std::string);
	void composeItem(int, std::string, std::string, std::string,	std::string);
	void onDungeon(int, std::string, std::string, int, std::string);
	void beginQuest(std::string);
	void onReqFriend(int, std::string, int, int);
	void attachEquip(int, std::string, std::string, std::string,	int, std::string);
	void getAPetEgg(int,	std::string, std::string, int);
	void upgradeEquip(int,std::string,std::string,int,std::string);
	void getDiamond(int,	std::string);
	void promoteEquip(int,std::string,std::string,int,std::string);
	void onCopy(int, std::string, std::string, std::string, bool);
	void useAPetEgg(int,std::string,std::string,int);
	void useDiamond(std::string,int,int);
	void onReqFriend(int,std::string,int,int);
	void roleDead(int,std::string,std::string,std::string);
	void onEliteCopy(int,std::string,std::string,std::string,bool);
	void onStart(void);
	void onTeamCopy(int,std::string,std::string,std::string,int,std::string,bool);
	void upgradeEquip(int, std::string, std::string, int, std::string);
	void onDungeon(int,std::string,std::string,int,std::string);
	void onCopy(int,std::string,std::string,std::string,bool);
	void onPvp(int, std::string,	std::string, std::string, bool);
}
#endif