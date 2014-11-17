#ifndef MOF_FUNNYACTUI_H
#define MOF_FUNNYACTUI_H

class FunnyActUI{
public:
	void goFunny_CapsuleEgg(int);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onAssignCCBMemberVariable(cocos2d::CCObject	*,char const*,cocos2d::CCNode *);
	void goFunny_Lottery(int);
	void create(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void goFunny_Dice(int);
	void ccTouchCancelled(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode	*);
	void recvContentClicked(int);
	void onAssignCCBMemberVariable(cocos2d::CCObject	*, char	const*,	cocos2d::CCNode	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void goFunny_BoxAward(int);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void onAssignCCBMemberVariable(cocos2d::CCObject *, char const*, cocos2d::CCNode *);
	void initGotoFunc(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void FunnyActUI(void);
	void ccTouchCancelled(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onEnter(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void ~FunnyActUI();
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void findType(std::string);
	void init(void);
	void onExit(void);
}
#endif