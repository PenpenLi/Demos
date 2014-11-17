#ifndef MOF_MYSTICMERCHANTCONTAINER_H
#define MOF_MYSTICMERCHANTCONTAINER_H

class MySticMerchantContainer{
public:
	void ~MySticMerchantContainer();
	void createEffect(cocos2d::CCNode	*);
	void MySticMerchantContainer(void);
	void createPropsExchangeNode(cocos2d::CCNode *,MysteriousInfo *,bool);
	void create(void);
	void createContent(void);
	void onDescAwardTouchUpOutsideClicked(cocos2d::CCObject *);
	void createPropsExchangeNode(cocos2d::CCNode *, MysteriousInfo *,	bool);
	void onDescTouchDownClicked(cocos2d::CCObject *);
	void createMySticMerchantNode(cocos2d::CCNode *, MysteriousInfo *, bool);
	void onEnter(void);
	void createMySticMerchantNode(cocos2d::CCNode *,MysteriousInfo *,bool);
	void createControl(void);
	void onDescAwardTouchUpInsideClicked(cocos2d::CCObject *);
	void onDescAwardDragInsideClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
}
#endif