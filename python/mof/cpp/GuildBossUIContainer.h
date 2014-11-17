#ifndef MOF_GUILDBOSSUICONTAINER_H
#define MOF_GUILDBOSSUICONTAINER_H

class GuildBossUIContainer{
public:
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char	const*);
	void create(void);
	void recv(int,	void *);
	void initControl(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void recv(int, int, cocos2d::CCPoint, int);
	void ccTouchCancelled(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void recv(int,	int, cocos2d::CCPoint, int);
	void recv(void	*);
	void createItemBtn(int, int);
	void ccTouchCancelled(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setMaterialShow(ItemCfgDef *, bool);
	void onItemDragInsideClicked(cocos2d::CCObject *);
	void recv(int, void *);
	void recv(void *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void recv(int,int,char	const*);
	void onItemTouchDownClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void recv(int,int,char const*);
	void onItemTouchDownClicked(cocos2d::CCObject	*);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void recv(int,int,cocos2d::CCPoint,int);
	void onItemTouchUpOutsideClicked(cocos2d::CCObject *);
	void createItemBtn(int,int);
	void GuildBossUIContainer(void);
	void recv(int, int, char const*);
	void recv(int,void *);
	void LoadBagItems(void);
	void clearBagItem(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onMenuItemChooseClicked(cocos2d::CCObject *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onTipsHide(void);
	void onEnter(void);
	void onItemTouchUpInsideClicked(cocos2d::CCObject *);
	void Init(void);
	void setMaterialShow(ItemCfgDef *,bool);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void recv(int,	int, char const*);
	void ~GuildBossUIContainer();
	void ReLoadBagItems(void);
	void init(void);
	void onExit(void);
}
#endif