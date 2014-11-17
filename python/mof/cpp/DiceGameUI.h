#ifndef MOF_DICEGAMEUI_H
#define MOF_DICEGAMEUI_H

class DiceGameUI{
public:
	void onMenuItemCloseRuleClicked(cocos2d::CCObject *);
	void hideHistroy(void);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onAssignCCBMemberVariable(cocos2d::CCObject	*,char const*,cocos2d::CCNode *);
	void onMenuItemRmbRollClicked(cocos2d::CCObject *);
	void calFunEndScale(cocos2d::CCNode *);
	void onMenuItemCloseRoundOverClicked(cocos2d::CCObject *);
	void onMenuItemCloseRoundOverClicked(cocos2d::CCObject	*);
	void onMenuItemCloseHistoryClicked(cocos2d::CCObject *);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setRollNumber(void);
	void calFunMoveAct(void);
	void setHistroy(void);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode	*);
	void onAssignCCBMemberVariable(cocos2d::CCObject	*, char	const*,	cocos2d::CCNode	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setRoundOver(void);
	void rollDelay(void);
	void DiceGameUI(void);
	void moveChessAction(int, int);
	void resetDice(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onMenuItemHistoryClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void playDiceAnim(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void onAssignCCBMemberVariable(cocos2d::CCObject *, char const*, cocos2d::CCNode *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void calOneMove(void);
	void onMenuItemRmbRollClicked(cocos2d::CCObject	*);
	void calFunAward(void);
	void changeRollMenu(void);
	void playAwardEffect(cocos2d::CCNode *);
	void initChessPos(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void initAward(void);
	void posToPos(int);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onMenuItemHistoryClicked(cocos2d::CCObject	*);
	void moveChessAction(int,int);
	void setRollMenuPause(void);
	void setFreeTimes(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void onMenuItemGameRuleClicked(cocos2d::CCObject *);
	void setRmbNeed(void);
	void awardTips(int);
	void setHelp(void);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void endDiceAnim(void);
	void create(void);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void onMenuItemFreeRollClicked(cocos2d::CCObject *);
	void initData(void);
	void calFunScaleAct(cocos2d::CCNode *);
	void ~DiceGameUI();
	void setRollMenuRun(void);
	void init(void);
	void onExit(void);
	void onEnter(void);
}
#endif