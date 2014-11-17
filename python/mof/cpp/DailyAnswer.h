#ifndef MOF_DAILYANSWER_H
#define MOF_DAILYANSWER_H

class DailyAnswer{
public:
	void onMenuItemBclicked(cocos2d::CCObject *);
	void setAward(int, int, int);
	void create(void);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onMenuItemCommitClicked(cocos2d::CCObject *);
	void setRemainQuestionNum(int);
	void onMenuItemChangeQuestionClicked(cocos2d::CCObject *);
	void refreshTimer(float);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void DailyAnswer(void);
	void setChangeImageState(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*, char	const*);
	void isGameOver(bool);
	void addAttachChild(char const*, char	const*);
	void ~DailyAnswer();
	void onMenuItemChangeQuestionClicked(cocos2d::CCObject	*);
	void showCallBack(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setChangeNum(int);
	void ccTouchEnded(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void setChangeCost(int);
	void initShow(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void showTips(bool);
	void onMenuItemCloseClicked(cocos2d::CCObject	*);
	void onMenuItemAwardClicked(cocos2d::CCObject	*);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void onMenuItemCclicked(cocos2d::CCObject *);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onMenuItemAclicked(cocos2d::CCObject *);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onMenuItemDclicked(cocos2d::CCObject *);
	void onEnter(void);
	void setScore(int);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void setAward(int,int,int);
	void setItemAward(int);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*,char const*);
	void showQuestion(int, int);
	void showAwardNode(bool);
	void ccTouchMoved(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onMenuItemAwardClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void addAttachChild(char const*,char const*);
	void onMenuItemCommitClicked(cocos2d::CCObject	*);
	void showQuestion(int,int);
	void setRightNum(int);
	void init(void);
	void onExit(void);
}
#endif