#ifndef MOF_GUILDMEMBER_H
#define MOF_GUILDMEMBER_H

class GuildMember{
public:
	void setMemberNowNum(void);
	void onMenuItemIntroduceClicked(cocos2d::CCObject *);
	void deleteSingleData(int);
	void onMenuItemAddFriendClick(cocos2d::CCObject *);
	void onMenuItemCloseIntroduceClicked(cocos2d::CCObject *);
	void ~GuildMember();
	void addGuildMembers(void);
	void onMenuItemRefreshListClick(cocos2d::CCObject *);
	void onMenuItemImpeachOKClicked(cocos2d::CCObject *);
	void onMenuItemImpeachAboutClicked(cocos2d::CCObject *);
	void onMenuItemImpeachAboutClosedClicked(cocos2d::CCObject *);
	void onMenuItemGobackClick(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*, char	const*);
	void onMenuItemTransCancle(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void reqAppointPosition(GuildMemberPosition);
	void setGuildPermissions(void);
	void deleteAllData(void);
	void onMenuItemResetClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onMenuItemViceMasterClicked(cocos2d::CCObject *);
	void onMenuItemTransOK(void);
	void onMenuItemHandleClick(cocos2d::CCObject *);
	void GuildMember(void);
	void showImpeachTips(bool);
	void onMenuItemKickOutOK(void);
	void onMenuItemKickOutClick(cocos2d::CCObject	*);
	void initMember(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void showGuildMemberRank(void);
	void onMenuItemTransforClick(cocos2d::CCObject *);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onMenuItemImpeachClicked(cocos2d::CCObject *);
	void showImpeachPrice(void);
	void onEnter(void);
	void onMenuItemCloseIntroduceClicked(cocos2d::CCObject	*);
	void onMenuItemImpeachCancelClicked(cocos2d::CCObject *);
	void onMenuItemTransforClick(cocos2d::CCObject	*);
	void initPositionListNode(void);
	void onMenuItemKickOutClick(cocos2d::CCObject *);
	void showPositionListNode(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*,char const*);
	void create(void);
	void ccTouchBegan(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void onMenuItemKickOutCancel(void);
	void onExit(void);
	void onMenuItemGuildMemberClicked(cocos2d::CCObject *);
	void onMenuItemImpeachCancelClicked(cocos2d::CCObject	*);
	void init(void);
	void onMenuItemResetClicked(cocos2d::CCObject	*);
	void showImpeachInfo(GuildImpeachInfoError);
}
#endif