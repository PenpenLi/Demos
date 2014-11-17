#ifndef MOF_CHATTINGTABLEVIEW_H
#define MOF_CHATTINGTABLEVIEW_H

class ChattingTableView{
public:
	void scrollViewDidScroll(cocos2d::extension::CCScrollView	*);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView	*);
	void setTableShow(void);
	void tableCellSizeForIndex(cocos2d::extension::CCTableView *, unsigned int);
	void clearHightData(void);
	void addchatData(void);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void tableCellSizeForIndex(cocos2d::extension::CCTableView *,uint);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void clearHightDataByNum(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned	int);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void setTableViewShow(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void ~ChattingTableView();
	void Init(void);
	void ChattingTableView(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void initLabelsHightData(void);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void init(void);
}
#endif