#ifndef MOF_TREASURESCOREUI_H
#define MOF_TREASURESCOREUI_H

class TreasureScoreUI{
public:
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void ~TreasureScoreUI();
	void create(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void registerWithTouchDispatcher(void);
	void initPlayData(void);
	void onMenuItemCloseClick(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onEnter(void);
	void TreasureScoreUI(void);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void initRankData(void);
	void init(void);
	void onExit(void);
}
#endif