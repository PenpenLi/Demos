#ifndef MOF_BATTLESUCCESSUI_H
#define MOF_BATTLESUCCESSUI_H

class BattleSuccessUI{
public:
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void create(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void awardNodeMoveCallBack(float);
	void onMenuItemCheckAward(cocos2d::CCObject *);
	void BattleSuccessUI(void);
	void onMenuItemCheckCancel(cocos2d::CCObject *);
	void ccTouchCancelled(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void setStart(float);
	void onMenuItemGoCityClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void refreshData(float);
	void setreward(std::vector<ItemGroup, std::allocator<ItemGroup>>,	int, int, int, int, int);
	void refreshLimitCopyAward(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setSecondNode(float);
	void refreshCommonCopyAward(void);
	void winTitleIsShow(bool);
	void allItemsActionEnd(void);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setBattleValue(int,int,int,int);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void setBattleValue(int, int, int, int);
	void onEnter(void);
	void commomAwardIsShow(bool);
	void secondNodeCallBack(void);
	void Init(void);
	void ~BattleSuccessUI();
	void onMenuItemRightClicked(cocos2d::CCObject *);
	void showStarEffect(void);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void refreshResult(float);
	void setreward(std::vector<ItemGroup,std::allocator<ItemGroup>>,int,int,int,int,int);
	void onMenuItemLeftClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
}
#endif