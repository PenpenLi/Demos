#ifndef MOF_VIPCHARGEITEM_H
#define MOF_VIPCHARGEITEM_H

class VIPChargeitem{
public:
	void onReceiveTouchUpInsideClicked(cocos2d::CCObject	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void showItemName(cocos2d::CCNode *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*,char const*);
	void hideItemName(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onReceiveDragInsideClicked(cocos2d::CCObject *);
	void onReceiveTouchDownInside(cocos2d::CCObject *);
	void onReceiveTouchUpOutsideClicked(cocos2d::CCObject *);
	void create(void);
	void ~VIPChargeitem();
	void VIPChargeitem(void);
	void onEnter(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*, char	const*);
	void initVipContent(void);
	void onReceiveTouchUpInsideClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
}
#endif