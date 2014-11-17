#ifndef MOF_MONTHCARDTABLE_H
#define MOF_MONTHCARDTABLE_H

class MonthCardTable{
public:
	void onItemTochDownClicked(cocos2d::CCObject *);
	void onReceiveDragInsideClicked(cocos2d::CCObject *);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void refreshDatas(void);
	void tableCellHighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void MonthCardTable(void);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void ~MonthCardTable();
	void onReceiveTouchUpOutsideClicked(cocos2d::CCObject *);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell	*);
	void tableCellHighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void tableCellHighlight(cocos2d::extension::CCTableView *,	cocos2d::extension::CCTableViewCell *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void onReceiveTouchUpInsideClicked(cocos2d::CCObject *);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void reloadAllDatas(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *,	cocos2d::extension::CCTableViewCell *);
	void setCurCollectIndex(int);
	void init(void);
}
#endif