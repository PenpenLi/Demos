#ifndef MOF_TEAMTABLEVIEW_H
#define MOF_TEAMTABLEVIEW_H

class TeamTableView{
public:
	void tableCellUnhighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void TeamTableView(void);
	void ~TeamTableView();
	void tableCellTouched(cocos2d::extension::CCTableView	*,cocos2d::extension::CCTableViewCell *);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void tableCellTouched(cocos2d::extension::CCTableView	*, cocos2d::extension::CCTableViewCell *);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void tableCellHighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell	*);
	void tableCellHighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void cellSizeForTable(cocos2d::extension::CCTableView	*);
	void addTeamInfor(teamInfor);
	void refreshData(teamInfor);
	void setChoosedIconIsShow(int, bool);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void createControl(void);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void tableCellAtIndex(cocos2d::extension::CCTableView	*, unsigned int);
	void clearData(void);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void tableCellAtIndex(cocos2d::extension::CCTableView	*,uint);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void setChoosedIconIsShow(int,bool);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView	*);
	void tableCellHighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell	*);
	void init(void);
}
#endif