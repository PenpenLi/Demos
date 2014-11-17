#ifndef MOF_DUNGEONSUI_H
#define MOF_DUNGEONSUI_H

class DungeonsUI{
public:
	void showFriendDungeonTimes(void);
	void showDefendStatueData(void);
	void recv(int,	void *);
	void initControl(void);
	void recv(int,void *);
	void DungeonsUI(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setFriendDungShow(int);
	void recv(int,int,char	const*);
	void recv(int, void *);
	void recv(int,int,char const*);
	void recv(int,int,cocos2d::CCPoint,int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void recv(int,	int, char const*);
	void recv(int, int, cocos2d::CCPoint, int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void reqResetDungeons(void);
	void onMenuItemTheResetClicked(cocos2d::CCObject *);
	void ~DungeonsUI();
	void showChallengeData(void);
	void recv(int, int, char	const*);
	void onEnter(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void reqResetFriendDung(void);
	void refreshDungeonsUI(void);
	void create(void);
	void onMenuItemStartClicked(cocos2d::CCObject *);
	void recv(int,	int, cocos2d::CCPoint, int);
	void setRmbAndGold(void);
	void showFatValue(void);
	void setDungeonsShow(int);
	void init(void);
	void onExit(void);
}
#endif