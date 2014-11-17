#ifndef MOF_GUILDBOSSUI_H
#define MOF_GUILDBOSSUI_H

class GuildBossUI{
public:
	void recv(int, int, cocos2d::CCPoint,	int);
	void ackBossExp(int);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void recv(int,int,cocos2d::CCPoint,int);
	void calculateUpGrade(void);
	void onFeedRmbCloseClicked(cocos2d::CCObject *);
	void create(void);
	void setExpUpVisable(void);
	void initControl(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void GuildBossUI(void);
	void recv(int,void *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*, char	const*);
	void onMenuItemRmbFeedClicked(cocos2d::CCObject *);
	void unchoosItem(int);
	void createItemBtn(int, int);
	void FeedByItem(cocos2d::CCObject *);
	void setOpenTimeShow(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setMaterialShow(ItemCfgDef *, bool);
	void ccTouchEnded(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void recv(int, void *);
	void initBossFeedItemUiData(void);
	void initBoss(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onItemTouchDownClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void recv(int,int,char const*);
	void onItemTouchDownClicked(cocos2d::CCObject	*);
	void updataItemChoose(void);
	void onMenuItemFeedClicked(cocos2d::CCObject *);
	void onAssignCCBMemberVariable(cocos2d::CCObject *, char const*, cocos2d::CCNode *);
	void initBossRmbFeedUiData(void);
	void onItemTouchUpOutsideClicked(cocos2d::CCObject *);
	void createItemBtn(int,int);
	void showExpUp(int);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char	const*,cocos2d::CCNode *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void recv(int, int, char const*);
	void recv(int, int, cocos2d::CCPoint, int);
	void onMenuItemUnChooseClicked(cocos2d::CCObject *);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void FeedByRMB(cocos2d::CCObject *);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onEnter(void);
	void onMenuItemFightBossClicked(cocos2d::CCObject *);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void setMaterialShow(ItemCfgDef *,bool);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*,char const*);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode *);
	void ccTouchMoved(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onItemTouchUpInsideClicked(cocos2d::CCObject *);
	void ~GuildBossUI();
	void ccTouchBegan(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void chooseItem(int);
	void onMenuItemCloseClicked(cocos2d::CCObject	*);
	void init(void);
	void onExit(void);
	void hideTipsNode(void);
}
#endif