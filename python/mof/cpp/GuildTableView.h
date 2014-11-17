#ifndef MOF_GUILDTABLEVIEW_H
#define MOF_GUILDTABLEVIEW_H

class GuildTableView{
public:
	void updateGuildListDateByIndex(int);
	void ~GuildTableView();
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void GuildTableView(void);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void applyGuild(cocos2d::CCObject *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void addDatas(int,	int);
	void init(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void setApplyImageState(int, bool);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell	*);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void addDatas(int,int);
	void setApplyImageState(int,bool);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void Init(void);
}
#endif