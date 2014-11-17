#ifndef MOF_FAILAWARDUI_H
#define MOF_FAILAWARDUI_H

class FailAwardUI{
public:
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void FailAwardUI(void);
	void setreward(std::vector<ItemGroup,	std::allocator<ItemGroup>>, int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*,char const*);
	void registerWithTouchDispatcher(void);
	void ~FailAwardUI();
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*, char	const*);
	void jitterCallBack(void);
	void setreward(std::vector<ItemGroup,std::allocator<ItemGroup>>,int);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void onEnter(void);
	void onMenuItemGoCityClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onExit(void);
	void create(void);
	void init(void);
	void Init(void);
	void onMenuItemGoCityClicked(cocos2d::CCObject	*);
}
#endif