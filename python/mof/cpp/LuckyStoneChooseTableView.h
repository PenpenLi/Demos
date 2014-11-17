#ifndef MOF_LUCKYSTONECHOOSETABLEVIEW_H
#define MOF_LUCKYSTONECHOOSETABLEVIEW_H

class LuckyStoneChooseTableView{
public:
	void createControl(void);
	void tableCellHighlight(cocos2d::extension::CCTableView	*, cocos2d::extension::CCTableViewCell *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView	*);
	void initControl(void);
	void ~LuckyStoneChooseTableView();
	void scrollViewDidZoom(cocos2d::extension::CCScrollView	*);
	void onMenuItemCancelClicked(cocos2d::CCObject *);
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
	void showLuckStoneDetail(float);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned	int);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void LuckyStoneChooseTableView(void);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void showLuckStoneDetailInfo(int);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void tableCellHighlight(cocos2d::extension::CCTableView	*,cocos2d::extension::CCTableViewCell *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell	*);
	void init(void);
}
#endif