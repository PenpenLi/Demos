#ifndef MOF_BULKPURCHASEDIALOGUI_H
#define MOF_BULKPURCHASEDIALOGUI_H

class BulkPurchaseDialogUI{
public:
	void setSubMinIamgeDialog(cocos2d::CCObject	*));
	void setProdectName(std::string);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char	const*);
	void setProductLogo(cocos2d::CCSprite *);
	void setSubIamgeDialog(cocos2d::CCObject *));
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setAddMaxImageDialog(cocos2d::CCObject *));
	void setPrice(int, int, std::string);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void setAddImageDialog(cocos2d::CCObject *));
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setProdectDic(std::string);
	void setAddMaxImageDialog(cocos2d::CCObject	*));
	void onAssignCCBMemberVariable(cocos2d::CCObject *, char const*, cocos2d::CCNode *);
	void ~BulkPurchaseDialogUI();
	void setPrice(int,int,std::string);
	void BulkPurchaseDialogUI(void);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void setSubMinIamgeDialog(cocos2d::CCObject *));
	void setShoppingImageDialog(cocos2d::CCObject *));
	void onEnter(void);
	void setPropsNumAndLogo(cocos2d::CCSprite *,	int, int);
	void setCancelIamgeDialog(cocos2d::CCObject	*));
	void setPropsNumAndLogo(cocos2d::CCSprite *,int,int);
	void setProdectPriceLogo(cocos2d::CCSprite *);
	void setProdectPrice(std::string);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode *);
	void setBulkNum(int);
	void create(void);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void setShoppingImageState(bool);
	void setCancelIamgeDialog(cocos2d::CCObject *));
	void setProdectColor(cocos2d::_ccColor3B);
	void init(void);
	void onExit(void);
}
#endif