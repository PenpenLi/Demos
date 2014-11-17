#ifndef MOF_TASKDIALOG_H
#define MOF_TASKDIALOG_H

class TaskDialog{
public:
	void onMenuItemShowManorClicked(cocos2d::CCObject *);
	void setTaskManager(TaskManager *);
	void TaskDialog(void);
	void QuestStateToString(int);
	void destroyControl(void);
	void ~TaskDialog();
	void onCreateControl(void);
	void showQuestAward(int);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setDescTipShow(cocos2d::CCPoint,int);
	void getCondition(int,std::vector<int,std::allocator<int>> &);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void getCondition(int,	std::vector<int, std::allocator<int>> &);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void onDescAwardTouchUpInsideClicked(cocos2d::CCObject	*);
	void continueDialog(int);
	void onMeunButtonClick(cocos2d::CCObject *);
	void showDialog(void);
	void loadData(void);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void createDescTip(void);
	void onEnter(void);
	void CheckDialogQuest(int);
	void onDescAwardTouchUpInsideClicked(cocos2d::CCObject *);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void dialogEnd(Dialog *);
	void getDialogID(int, TaskState, int &);
	void create(void);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void ShowDialogContent(int);
	void onExit(void);
	void CheckAcceptQuest(int);
	void init(void);
	void getDialogID(int,TaskState,int &);
	void setDescTipShow(cocos2d::CCPoint, int);
}
#endif