#ifndef MOF_RANKTABLEVIEW_H
#define MOF_RANKTABLEVIEW_H

class RankTableView{
public:
	void RankTableView(void);
	void ~RankTableView();
	void tableCellTouched(cocos2d::extension::CCTableView	*,cocos2d::extension::CCTableViewCell *);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void addDatas(int, int);
	void tableCellTouched(cocos2d::extension::CCTableView	*, cocos2d::extension::CCTableViewCell *);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell	*);
	void addDatas(int,int);
	void cellSizeForTable(cocos2d::extension::CCTableView	*);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void Init(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView	*, unsigned int);
	void onMenuCheckPlayerClicked(cocos2d::CCObject *);
	void tableCellAtIndex(cocos2d::extension::CCTableView	*,uint);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void showCheckPlayerNode(cocos2d::CCNode *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView	*);
	void init(void);
}
#endif