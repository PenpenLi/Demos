#ifndef MOF_TASKUI_H
#define MOF_TASKUI_H

class TaskUI{
public:
	void showtaskType(int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char	const*);
	void deleteUnAcceptAllData(void);
	void AddAcceptTask(int);
	void transformToTaskInfor(int);
	void hideTaskUI(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void ccTouchBegan(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void reduceUnAcceptTask(int);
	void refreshData(int);
	void ccTouchBegan(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void recv(int, int, cocos2d::CCPoint, int);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onMenuItemAcceptTaskClicked(cocos2d::CCObject *);
	void onMenuItemUnacceptTaskClicked(cocos2d::CCObject *);
	void showTaskUI(void);
	void onEnter(void);
	void recv(int, int, char const*);
	void recv(int,int,cocos2d::CCPoint,int);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void ~TaskUI();
	void TaskUI(void);
	void recv(int,int,char const*);
	void deleteAcceptAllData(void);
	void create(void);
	void onMenuItemAcceptTaskClicked(cocos2d::CCObject	*);
	void AddUnAcceptTask(int);
	void reduceAcceptTask(int);
	void init(void);
	void onExit(void);
}
#endif