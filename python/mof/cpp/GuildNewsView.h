#ifndef MOF_GUILDNEWSVIEW_H
#define MOF_GUILDNEWSVIEW_H

class GuildNewsView{
public:
	void tableCellAtIndex(cocos2d::extension::CCTableView	*, unsigned int);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void addDatas(int, int);
	void tableCellTouched(cocos2d::extension::CCTableView	*, cocos2d::extension::CCTableViewCell *);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell	*);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void tableCellAtIndex(cocos2d::extension::CCTableView	*,uint);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void init(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void GuildNewsView(void);
	void ~GuildNewsView();
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView	*);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void addDatas(int,int);
	void Init(void);
	void cellSizeForTable(cocos2d::extension::CCTableView	*);
	void tableCellTouched(cocos2d::extension::CCTableView	*,cocos2d::extension::CCTableViewCell *);
}
#endif