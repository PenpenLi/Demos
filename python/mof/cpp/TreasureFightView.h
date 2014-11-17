#ifndef MOF_TREASUREFIGHTVIEW_H
#define MOF_TREASUREFIGHTVIEW_H

class TreasureFightView{
public:
	void scrollViewDidScroll(cocos2d::extension::CCScrollView	*);
	void onDescAwardTouchUpOutsideClicked(cocos2d::CCObject *);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView	*);
	void ~TreasureFightView();
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void addDatas(int, int);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void addDatas(int,int);
	void onDescAwardDragInsideClicked(cocos2d::CCObject *);
	void TreasureFightView(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned	int);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void onDescAwardTouchUpInsideClicked(cocos2d::CCObject *);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void onDescAwardTouchUpOutsideClicked(cocos2d::CCObject	*);
	void Init(void);
	void reloadRoomData(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void init(void);
	void onDescAwardTouchDownClicked(cocos2d::CCObject *);
}
#endif