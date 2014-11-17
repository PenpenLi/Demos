#ifndef MOF_WARDROBEAWARDTABLEVIEW_H
#define MOF_WARDROBEAWARDTABLEVIEW_H

class WardrobeAwardTableView{
public:
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void WardrobeAwardTableView(void);
	void addDatas(int);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void ~WardrobeAwardTableView();
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void create(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void deletAllDatas(void);
	void onEnter(void);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void createControl(void);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell	*);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void init(void);
}
#endif