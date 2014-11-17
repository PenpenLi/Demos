#ifndef MOF_FASHIONTABLEVIEW_H
#define MOF_FASHIONTABLEVIEW_H

class FashionTableView{
public:
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void tableCellTouched(cocos2d::extension::CCTableView *,	cocos2d::extension::CCTableViewCell *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void ~FashionTableView();
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,	unsigned int);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void createControl(void);
	void setCellSeleted(uint,bool);
	void refreshData(int);
	void setCellSeleted(unsigned int, bool);
	void FashionTableView(void);
	void init(void);
	void addDatas(void);
}
#endif