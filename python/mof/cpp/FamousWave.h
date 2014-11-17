#ifndef MOF_FAMOUSWAVE_H
#define MOF_FAMOUSWAVE_H

class FamousWave{
public:
	void tableCellUnhighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void setCellSeleted(uint,bool);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void tableCellTouched(cocos2d::extension::CCTableView *,	cocos2d::extension::CCTableViewCell *);
	void initData(void);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void tableCellHighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellHighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void tableCellHighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell	*);
	void setCellSeleted(unsigned int, bool);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell	*);
	void ~FamousWave();
	void FamousWave(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,	unsigned int);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void init(void);
}
#endif