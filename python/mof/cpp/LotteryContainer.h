#ifndef MOF_LOTTERYCONTAINER_H
#define MOF_LOTTERYCONTAINER_H

class LotteryContainer{
public:
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void addDatas(int, int);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void tableCellTouched(cocos2d::extension::CCTableView *,	cocos2d::extension::CCTableViewCell *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void deleteAllData(void);
	void ~LotteryContainer();
	void create(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,	unsigned int);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void LotteryContainer(void);
	void addDatas(int,int);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void setViewTouchEnable(bool);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void init(void);
	void Init(void);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
}
#endif