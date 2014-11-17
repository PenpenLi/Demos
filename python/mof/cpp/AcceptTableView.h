#ifndef MOF_ACCEPTTABLEVIEW_H
#define MOF_ACCEPTTABLEVIEW_H

class AcceptTableView{
public:
	void onGiveupTask(cocos2d::CCObject *);
	void AcceptTableView(void);
	void addTaskDate(TaskInfor);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned	int);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void onAutomaticTask(cocos2d::CCObject *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView	*);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void refreshAllData(void);
	void ~AcceptTableView();
	void create(void);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell	*);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void init(void);
	void refreshData(TaskInfor);
}
#endif