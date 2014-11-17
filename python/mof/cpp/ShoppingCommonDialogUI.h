#ifndef MOF_SHOPPINGCOMMONDIALOGUI_H
#define MOF_SHOPPINGCOMMONDIALOGUI_H

class ShoppingCommonDialogUI{
public:
	void setProdectName(std::string);
	void setProdectPriceLogo(cocos2d::CCSprite	*);
	void ShoppingCommonDialogUI(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char	const*);
	void setProductLogo(cocos2d::CCSprite *);
	void ~ShoppingCommonDialogUI();
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void ccTouchBegan(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setProdectDic(std::string);
	void onAssignCCBMemberVariable(cocos2d::CCObject *, char const*, cocos2d::CCNode *);
	void ccTouchBegan(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void setShoppingImageDialog(cocos2d::CCObject *));
	void onEnter(void);
	void setProdectPrice(std::string);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode *);
	void create(void);
	void setCancelIamgeDialog(cocos2d::CCObject *));
	void setProdectColor(cocos2d::_ccColor3B);
	void init(void);
	void onExit(void);
}
#endif