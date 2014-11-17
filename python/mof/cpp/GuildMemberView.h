#ifndef MOF_GUILDMEMBERVIEW_H
#define MOF_GUILDMEMBERVIEW_H

class GuildMemberView{
public:
	void deleteSingleData(int);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView	*);
	void ~GuildMemberView();
	void createCheckedNodeBox(float);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell	*);
	void initString(void);
	void setCellSelected(unsigned int, bool);
	void GuildMemberView(void);
	void setCellSelected(uint,bool);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned	int);
	void showCheckNode(cocos2d::CCNode *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void addDatas(void);
	void onCheckPlayerClick(cocos2d::CCObject	*);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void init(void);
	void Init(void);
}
#endif