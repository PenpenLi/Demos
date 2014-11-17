#ifndef MOF_TEAMWITHFRIENDS_H
#define MOF_TEAMWITHFRIENDS_H

class TeamWithFriends{
public:
	void onMenuItemGuildListClicked(cocos2d::CCObject	*);
	void initBlessUI(void);
	void showGuildMemberBlessTo(void);
	void recv(int,void *);
	void TeamWithFriends(void);
	void onMenuItemFriendListClicked(cocos2d::CCObject *);
	void recv(int, int,	cocos2d::CCPoint, int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void recv(int, void *);
	void recv(int,int,char const*);
	void showFriendsListByScene(bool);
	void refreshData(int);
	void recv(int, void	*);
	void addTeamInfor(teamInfor);
	void recv(int, int, char const*);
	void recv(int, int, cocos2d::CCPoint, int);
	void onMenuItemBlessClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onEnter(void);
	void recv(int,int,cocos2d::CCPoint,int);
	void ~TeamWithFriends();
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void recv(int, int,	char const*);
	void onMenuItemGuildListClicked(cocos2d::CCObject *);
	void setFriendImageIsEnable(bool);
	void create(void);
	void onMenuItemGoToItemCopyClicked(cocos2d::CCObject *);
	void onMenuItemFriendListClicked(cocos2d::CCObject	*);
	void init(void);
	void onExit(void);
}
#endif