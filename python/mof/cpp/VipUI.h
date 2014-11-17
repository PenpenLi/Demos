#ifndef MOF_VIPUI_H
#define MOF_VIPUI_H

class VipUI{
public:
	void setPageShow(int);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void setAwardImagesState(void);
	void initControl(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*, char	const*);
	void onMenuItemLeftClicked(cocos2d::CCObject	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void ccTouchEnded(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void showVipExp(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void showVipLevel(int, int,	float *);
	void showVipLevel(int,int,float *);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ~VipUI();
	void onEnter(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void VipUI(void);
	void onMenuItemRightClicked(cocos2d::CCObject *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*,char const*);
	void onMenuItemChargeClicked(cocos2d::CCObject *);
	void ccTouchMoved(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void create(void);
	void showAllVipShow(void);
	void ccTouchBegan(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void onMenuItemLeftClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
}
#endif