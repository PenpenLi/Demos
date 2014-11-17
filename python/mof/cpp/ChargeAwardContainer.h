#ifndef MOF_CHARGEAWARDCONTAINER_H
#define MOF_CHARGEAWARDCONTAINER_H

class ChargeAwardContainer{
public:
	void onItemTochDownClicked(cocos2d::CCObject *);
	void onReceiveDragInsideClicked(cocos2d::CCObject *);
	void onReceiveDragInsideClicked(cocos2d::CCObject	*);
	void adjustScrollView(cocos2d::extension::CCScrollView *,int,int	*);
	void ~ChargeAwardContainer();
	void initContent(std::vector<ChargeActItemDef *,std::allocator<ChargeActItemDef *>>);
	void create(void);
	void onReceiveTouchUpOutsideClicked(cocos2d::CCObject *);
	void initContent(std::vector<ChargeActItemDef *,	std::allocator<ChargeActItemDef	*>>);
	void onExit(void);
	void onEnter(void);
	void onMenuItemGetClicked(cocos2d::CCObject *);
	void ChargeAwardContainer(void);
	void onReceiveTouchUpInsideClicked(cocos2d::CCObject *);
	void init(void);
	void changeGetState(int);
	void hideAwardInfo(void);
}
#endif