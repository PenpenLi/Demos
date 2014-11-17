#ifndef MOF_MYSTICALCOPYUI_H
#define MOF_MYSTICALCOPYUI_H

class MysticalCopyUI{
public:
	void create(void);
	void ~MysticalCopyUI();
	void ccTouchMoved(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char	const*);
	void onMenuItemDialogCloseClicked(cocos2d::CCObject	*);
	void labelTimeAction(void);
	void initControl(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void destroyAwardScroll(void);
	void setDialogContent(int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void refreshBossUI(void);
	void onMenuItemGotoCityClicked(cocos2d::CCObject *);
	void onMenuItemPreClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void labelDesAction(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void registerWithTouchDispatcher(void);
	void onMenuItemPreClicked(cocos2d::CCObject	*);
	void ccTouchEnded(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void MysticalCopyUI(void);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onEnter(void);
	void setCurPage(void);
	void updateRefreshTime(float);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void ccTouchEnded(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void Init(void);
	void onMenuItemDialogCloseClicked(cocos2d::CCObject *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void onMenuItemNextClicked(cocos2d::CCObject *);
	void ccTouchMoved(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void init(void);
	void onExit(void);
	void destoryBossScorllView(void);
}
#endif