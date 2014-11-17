#ifndef MOF_CAPSULETOYUI_H
#define MOF_CAPSULETOYUI_H

class CapsuleToyUI{
public:
	void onMenuItemQuaType2Clicked(cocos2d::CCObject *);
	void setAwardMark(int);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void calBack(void);
	void scheduleTypeTime(int);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void showAwardStr(cocos2d::CCNode *,	void *);
	void onMenuItemEgg3Clicked(cocos2d::CCObject	*);
	void showCapsuleToyAward(int,int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char	const*);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void initControl(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onMenuItemEgg1Clicked(cocos2d::CCObject	*);
	void onMenuItemEgg2Clicked(cocos2d::CCObject *);
	void ccTouchCancelled(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void updateType2Time(float);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode	*);
	void onMenuItemEgg4Clicked(cocos2d::CCObject *);
	void setCapsuleBuyOrPresent(int,bool);
	void ccTouchCancelled(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void onMenuItemQuaType1Clicked(cocos2d::CCObject *);
	void showFreeGetNumUseUp(int,bool);
	void showCapsuleToyAward(int, int);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void onMenuItemQuaType4Clicked(cocos2d::CCObject *);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void onMenuItemEgg2Clicked(cocos2d::CCObject	*);
	void updateType1Time(float);
	void onMenuItemEgg4Clicked(cocos2d::CCObject	*);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onMenuItemXyCapsuleToyOK(void);
	void registerWithTouchDispatcher(void);
	void CapsuleToyUI(void);
	void onAssignCCBMemberVariable(cocos2d::CCObject *, char const*, cocos2d::CCNode *);
	void onMenuItemEgg1Clicked(cocos2d::CCObject *);
	void setCapsuleBuyOrPresent(int, bool);
	void showCapsuleToyEffect(void);
	void setAwardTipPos(bool, cocos2d::CCPoint);
	void updateType3Time(float);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onMenuItemCloseClicked(cocos2d::CCObject	*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onMenuItemQuaType3Clicked(cocos2d::CCObject *);
	void freshTimer(int);
	void setCapsuleToyPrice(int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onEnter(void);
	void showPresentBuyTimes(int,int);
	void setAwardTipPos(bool,cocos2d::CCPoint);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void onMenuItemEgg3Clicked(cocos2d::CCObject *);
	void setAllButtonEnable(bool);
	void setAwardTipDesc(std::string);
	void create(void);
	void setCapsuleFreeOrBuy(int,bool);
	void setPresentNumTip(void);
	void setCapsuleFreeOrBuy(int, bool);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode *);
	void showPresentBuyTimes(int, int);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void showFreeGetNumUseUp(int, bool);
	void onMenuItemCapsuleToyCancel(void);
	void ~CapsuleToyUI();
	void showCapsuleToyAwardEffect(cocos2d::CCNode *);
	void onMenuItemCapsuleToyOK(void);
	void init(void);
	void onExit(void);
	void showAwardStr(cocos2d::CCNode *,void *);
}
#endif