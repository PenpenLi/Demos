#ifndef MOF_PETARENATABLEVIEW_H
#define MOF_PETARENATABLEVIEW_H

class PetArenaTableView{
public:
	void ~PetArenaTableView();
	void PetArenaTableView(void);
	void tableCellHighlight(cocos2d::extension::CCTableView	*, cocos2d::extension::CCTableViewCell *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView	*);
	void initControl(void);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView	*);
	void tableCellUnhighlight(cocos2d::extension::CCTableView	*,cocos2d::extension::CCTableViewCell *);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void addDatas(void);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void onMenuConfirmClicked(cocos2d::CCObject *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void tableCellHighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellHighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void tableCellUnhighlight(cocos2d::extension::CCTableView	*, cocos2d::extension::CCTableViewCell *);
	void tableCellHighlight(cocos2d::extension::CCTableView	*,cocos2d::extension::CCTableViewCell *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned	int);
	void gobackChooseIndex(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void createControl(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell	*);
	void init(void);
}
#endif