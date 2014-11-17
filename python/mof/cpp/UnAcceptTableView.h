#ifndef MOF_UNACCEPTTABLEVIEW_H
#define MOF_UNACCEPTTABLEVIEW_H

class UnAcceptTableView{
public:
	void addTaskDate(TaskInfor);
	void UnAcceptTableView(void);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned	int);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView	*);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView	*);
	void ~UnAcceptTableView();
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void create(void);
	void acceptTask(cocos2d::CCObject *);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void init(void);
	void refreshData(TaskInfor);
}
#endif