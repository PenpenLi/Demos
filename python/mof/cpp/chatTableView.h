#ifndef MOF_CHATTABLEVIEW_H
#define MOF_CHATTABLEVIEW_H

class chatTableView{
public:
	void tableCellTouched(cocos2d::extension::CCTableView	*,cocos2d::extension::CCTableViewCell *);
	void AddData(charting);
	void tableCellSizeForIndex(cocos2d::extension::CCTableView *, unsigned int);
	void tableCellTouched(cocos2d::extension::CCTableView	*, cocos2d::extension::CCTableViewCell *);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void tableCellSizeForIndex(cocos2d::extension::CCTableView *,uint);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell	*);
	void tableCellSizeForIndex(cocos2d::extension::CCTableView *,	unsigned int);
	void cellSizeForTable(cocos2d::extension::CCTableView	*);
	void ~chatTableView();
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void chatTableView(void);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void Init(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView	*, unsigned int);
	void tableCellAtIndex(cocos2d::extension::CCTableView	*,uint);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView	*);
	void init(void);
}
#endif