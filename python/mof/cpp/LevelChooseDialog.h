#ifndef MOF_LEVELCHOOSEDIALOG_H
#define MOF_LEVELCHOOSEDIALOG_H

class LevelChooseDialog{
public:
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void hidePetEliteAccess(void);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onMenuClosePetEliteEntryClicked(cocos2d::CCObject *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setPetIconLabelTip(int,cocos2d::CCPoint,bool);
	void onMenuItemInviteFriends(cocos2d::CCObject *);
	void create(void);
	void showPetEliteAccess(int);
	void DeleteSprite(void);
	void onMenuItemBuyTimesClicked(cocos2d::CCObject	*);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onMenuPetEliteSelClicked(cocos2d::CCObject	*);
	void onMenuItemWipeoutClicked(cocos2d::CCObject *);
	void deleteCompletePrintCopy(int);
	void updateFliping(float);
	void onMenuItemCancelClicked(cocos2d::CCObject *);
	void ccTouchCancelled(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void setDialogContent(int);
	void onMenuItemBuyNUmClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void destroyAwardScroll(void);
	void onMenuItemGotoCityClicked(cocos2d::CCObject *);
	void onMenuItemGotoCityClicked(cocos2d::CCObject	*);
	void CreateLevelTips(int);
	void onMenuItemWipeoutClicked(cocos2d::CCObject	*);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void createAwardScroll(std::vector<int,	std::allocator<int>> &);
	void onMenuItemBuyTimesClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void InitControl(void);
	void showCostMoney(int);
	void showArrowUp(bool);
	void setPetFightIcon(void);
	void showArrow(bool);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void setCityName(int);
	void createAwardScroll(std::vector<int,std::allocator<int>> &);
	void setRemainingNum(int);
	void setSpirtePostion(int);
	void deleteRefreshPrintCopy(int);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onMenuItemRightClicked(cocos2d::CCObject *);
	void deleteCompleteCopyTag(int);
	void ~LevelChooseDialog();
	void onMenuPetEliteEntryClicked(cocos2d::CCObject *);
	void HideGotoCopyDialog(void);
	void onEnter(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void setEnergyValueShow(int);
	void onMenuItemDialogCloseClicked(cocos2d::CCObject *);
	void setPetEliteCotent(int);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void AddLevelDate(std::vector<int, std::allocator<int>>);
	void onMenuPetEliteSelClicked(cocos2d::CCObject *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void setPetIconLabelTip(int, cocos2d::CCPoint, bool);
	void AddLevelDate(std::vector<int,std::allocator<int>>);
	void setMyEnergyFValueShow(void);
	void onMenuItemLeftClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
}
#endif