#ifndef MOF_OPERATEPETTABLEVIEW_H
#define MOF_OPERATEPETTABLEVIEW_H

class OperatePetTableView{
public:
	void OperatePetTableView(void);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellHighlight(cocos2d::extension::CCTableView	*, cocos2d::extension::CCTableViewCell *);
	void initControl(void);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView	*);
	void tableCellTouched(cocos2d::extension::CCTableView	*,cocos2d::extension::CCTableViewCell *);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void addDatas(void);
	void tableCellTouched(cocos2d::extension::CCTableView	*, cocos2d::extension::CCTableViewCell *);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void onMenuConfirmClicked(cocos2d::CCObject *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void tableCellHighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void cellSizeForTable(cocos2d::extension::CCTableView	*);
	void ~OperatePetTableView();
	void tableCellHighlight(cocos2d::extension::CCTableView	*,cocos2d::extension::CCTableViewCell *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void onEnter(void);
	void createControl(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void tableCellAtIndex(cocos2d::extension::CCTableView	*, unsigned int);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void tableCellAtIndex(cocos2d::extension::CCTableView	*,uint);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void onMenuItemCloseClicked(cocos2d::CCObject	*);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell	*);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView	*);
	void tableCellHighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell	*);
	void init(void);
}
#endif