#ifndef MOF_ORDINARYACTIVITYUI_H
#define MOF_ORDINARYACTIVITYUI_H

class OrdinaryActivityUI{
public:
	void removeAllNewPromotUIs(void);
	void initControl(float);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void create(void);
	void playFriendCopy(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void playTicketCopy(void);
	void playPetArena(void);
	void ccTouchCancelled(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void playUnderCopy(void);
	void onMenuItemEquipActClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void initScrollView(void);
	void playPetCopy(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void playEliteCopy(void);
	void ~OrdinaryActivityUI();
	void OrdinaryActivityUI(void);
	void onMenuItemPetActClicked(cocos2d::CCObject	*);
	void setActivittImageIsEnable(bool);
	void showArrowsPromptUI(void);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void deleteNewPromotUIByActivityId(int);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void onEnter(void);
	void setMenuBtnEnable(int);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void onMenuItemGoToActivityClicked(cocos2d::CCObject *);
	void onMenuItemRightClicked(cocos2d::CCObject *);
	void onMenuItemPetActClicked(cocos2d::CCObject *);
	void playFamousHall(void);
	void showActivityDesc(OrdinaryActivityCfgDef *);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void playPetEliteCopy(void);
	void initCallback(void);
	void onMenuItemLeftClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
}
#endif