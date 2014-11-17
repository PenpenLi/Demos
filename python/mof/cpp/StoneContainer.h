#ifndef MOF_STONECONTAINER_H
#define MOF_STONECONTAINER_H

class StoneContainer{
public:
	void onItemTochDownClicked(cocos2d::CCObject *);
	void clearBagItems(void);
	void ccTouchMoved(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char	const*);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void recv(int, int, char const*);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void recv(int, int, cocos2d::CCPoint, int);
	void CreateItemBtn(int,int);
	void loadBagItems(operationtype);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void onItemDragInsideClicked(cocos2d::CCObject *);
	void recv(void *);
	void ccTouchBegan(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void recv(int, void *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void recv(int,int,char const*);
	void setMaterialShow(ItemCfgDef *,	bool, operationtype);
	void recv(int,int,cocos2d::CCPoint,int);
	void onItemTouchUpOutsideClicked(cocos2d::CCObject *);
	void onMenuItemsyntheticClicked(cocos2d::CCObject *);
	void ccTouchEnded(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void recv(int,void *);
	void onItemTouchUpOutsideClicked(cocos2d::CCObject	*);
	void StoneContainer(void);
	void recv(int,void	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onTipsHide(void);
	void onEnter(void);
	void ~StoneContainer();
	void onItemTouchUpInsideClicked(cocos2d::CCObject *);
	void ccTouchEnded(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void Init(void);
	void setMaterialShow(ItemCfgDef *,bool,operationtype);
	void create(void);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void mosaicClicked(int);
	void ccTouchMoved(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void init(void);
	void onExit(void);
	void CreateItemBtn(int, int);
}
#endif