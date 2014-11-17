#ifndef MOF_FASHIONAWARDTABLEVIEW_H
#define MOF_FASHIONAWARDTABLEVIEW_H

class FashionAwardTableView{
public:
	void deletAllDatas(void);
	void tableCellTouched(cocos2d::extension::CCTableView	*,cocos2d::extension::CCTableViewCell *);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void tableCellTouched(cocos2d::extension::CCTableView	*, cocos2d::extension::CCTableViewCell *);
	void setFashionID(int);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell	*);
	void cellSizeForTable(cocos2d::extension::CCTableView	*);
	void getFashionID(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void createControl(void);
	void addDatas(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView	*, unsigned int);
	void FashionAwardTableView(void);
	void getFashionID(void)const;
	void tableCellAtIndex(cocos2d::extension::CCTableView	*,uint);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView	*);
	void init(void);
	void ~FashionAwardTableView();
}
#endif