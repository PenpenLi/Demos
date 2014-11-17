#ifndef MOF_RANKUI_H
#define MOF_RANKUI_H

class RankUI{
public:
	void showMyPvpRank(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char	const*);
	void setTableViewShow(int);
	void initControl(void);
	void showRankbyIndex(int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void ccTouchBegan(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setPersonData(void);
	void ccTouchBegan(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void RankUI(void);
	void onEnter(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void deleteAllData(SortType);
	void showMyRank(SortType);
	void create(void);
	void onMenuItemTitleClicked(cocos2d::CCObject *);
	void onExit(void);
	void init(void);
	void ~RankUI();
}
#endif