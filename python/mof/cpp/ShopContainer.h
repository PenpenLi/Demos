#ifndef MOF_SHOPCONTAINER_H
#define MOF_SHOPCONTAINER_H

class ShopContainer{
public:
	void initRemainGoodsNode(cocos2d::CCNode *,RandGoodsDef *);
	void onShopDragInsideClicked(cocos2d::CCObject *);
	void onShopTouchDownClicked(cocos2d::CCObject *);
	void onShopTouchUpInsideClicked(cocos2d::CCObject *);
	void onShopTouchUpOutsideClicked(cocos2d::CCObject *);
	void initGoodsNode(cocos2d::CCNode *, GuildShopData	*);
	void init(void);
	void ~ShopContainer();
	void initRemainGoodsNode(cocos2d::CCNode *,	RandGoodsDef *);
	void initGoodsNode(cocos2d::CCNode *,GuildShopData *);
	void initControl(void);
	void onEnter(void);
	void create(void);
	void createContent(void);
	void ShopContainer(void);
	void onExit(void);
}
#endif