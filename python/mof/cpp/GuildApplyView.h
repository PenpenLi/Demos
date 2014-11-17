#ifndef MOF_GUILDAPPLYVIEW_H
#define MOF_GUILDAPPLYVIEW_H

class GuildApplyView{
public:
	void create(void);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void deleteSingleData(int);
	void ~GuildApplyView();
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void rejectGuild(cocos2d::CCObject *);
	void addDatas(int,	int);
	void Init(void);
	void initString(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell	*);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void agreeGuild(cocos2d::CCObject *);
	void rejectGuild(cocos2d::CCObject	*);
	void GuildApplyView(void);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void addDatas(int,int);
	void init(void);
}
#endif