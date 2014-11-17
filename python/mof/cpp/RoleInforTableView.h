#ifndef MOF_ROLEINFORTABLEVIEW_H
#define MOF_ROLEINFORTABLEVIEW_H

class RoleInforTableView{
public:
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void tableCellTouched(cocos2d::extension::CCTableView *,	cocos2d::extension::CCTableViewCell *);
	void changeRoleState(int, int);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void refreshData(tableViewData);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void Init(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void addData(tableViewData);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,	unsigned int);
	void ~RoleInforTableView();
	void RoleInforTableView(void);
	void changeRoleState(int,int);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void init(void);
	void deleteData(int);
}
#endif