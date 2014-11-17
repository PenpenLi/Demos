#ifndef MOF_BAGITEMSUI_H
#define MOF_BAGITEMSUI_H

class BagItemsUI{
public:
	void onItemTochDownClicked(cocos2d::CCObject *);
	void clearBagItems(void);
	void onMenuItemOpenAllGiftClicked(cocos2d::CCObject *);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void recv(int,int,cocos2d::CCPoint,int);
	void useRenameCard(void);
	void create(void);
	void onMenuItemOpenGiftClicked(cocos2d::CCObject *);
	void recv(int,	void *);
	void setgiftShow(ItemCfgDef *,	int, std::string);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void getOpenImageWorldPoint(void);
	void recv(int, int, cocos2d::CCPoint, int);
	void ccTouchCancelled(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void setOpenAllIsShow(bool);
	void CreateItemBtn(int,int);
	void recv(void	*);
	void sellItem(void);
	void ccTouchCancelled(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setgiftShow(ItemCfgDef *,int,std::string);
	void setMaterialShow(ItemCfgDef *, bool);
	void onItemDragInsideClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void recv(int,int,char	const*);
	void recv(int, void *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void recv(int,int,char const*);
	void reqSyntheticItem(int);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void BagItemsUI(void);
	void reqOpenGiftMessage(void);
	void onItemTouchUpOutsideClicked(cocos2d::CCObject *);
	void onMenuItemsyntheticClicked(cocos2d::CCObject *);
	void onItemDragInsideClicked(cocos2d::CCObject	*);
	void recv(int,void *);
	void getWorldPointByItem(int);
	void onMenuItemToSellClicked(cocos2d::CCObject *);
	void recv(void *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void recv(int,	int, cocos2d::CCPoint, int);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ~BagItemsUI();
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onMenuItemToSellClicked(cocos2d::CCObject	*);
	void onTipsHide(void);
	void onEnter(void);
	void onItemTouchUpInsideClicked(cocos2d::CCObject *);
	void Init(void);
	void setMaterialShow(ItemCfgDef *,bool);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void loadBagItems(void);
	void setShowButton(void);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void openPetEgg(int);
	void getStoneProperty(ItemCfgDef *, std::string &, std::string	&);
	void recv(int,	int, char const*);
	void getStoneProperty(ItemCfgDef *,std::string	&,std::string &);
	void recv(int, int, char	const*);
	void init(void);
	void onExit(void);
	void CreateItemBtn(int, int);
}
#endif