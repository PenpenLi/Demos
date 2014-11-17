#ifndef MOF_FUNNYTABLEVIEW_H
#define MOF_FUNNYTABLEVIEW_H

class FunnyTableView{
public:
	void InitControl(void);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void tableCellHighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void wakeUp(float);
	void tableCellHighlight(cocos2d::extension::CCTableView *,	cocos2d::extension::CCTableViewCell *);
	void tableCellHighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell	*);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void ~FunnyTableView();
	void reloadAllDatas(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *,	cocos2d::extension::CCTableViewCell *);
	void FunnyTableView(void);
	void init(void);
}
#endif