#ifndef MOF_TREASUREMANORSUI_H
#define MOF_TREASUREMANORSUI_H

class TreasureManorsUI{
public:
	void setCanAwardState(int);
	void TreasureManorsUI(void);
	void ccTouchMoved(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void onMenuItemTown4Clicked(cocos2d::CCObject *);
	void ~TreasureManorsUI();
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onMenuItemTown1Clicked(cocos2d::CCObject *);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void create(void);
	void init(void);
	void setTownIndex(int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onMenuItemTown5Clicked(cocos2d::CCObject *);
	void onMenuItemTown2Clicked(cocos2d::CCObject *);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void ccTouchEnded(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void setNumBGColor(std::string);
	void onMenuItemCloseClick(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onEnter(void);
	void ccTouchMoved(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void setManorsDataByTownIndex(int);
	void ccTouchEnded(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void setNameBGColor(std::string);
	void setTown1ManorsData(void);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void onMenuItemTown3Clicked(cocos2d::CCObject *);
	void getTownIndex(void)const;
	void getTownIndex(void);
	void onMenuItemAwardClicked(cocos2d::CCObject *);
	void onExit(void);
	void setTownSpr(std::string);
}
#endif