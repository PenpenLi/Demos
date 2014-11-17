#ifndef MOF_TOTEMPETTABLEVIEW_H
#define MOF_TOTEMPETTABLEVIEW_H

class TotemPetTableView{
public:
	void scrollViewDidScroll(cocos2d::extension::CCScrollView	*);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView	*);
	void ~TotemPetTableView();
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void TotemPetTableView(void);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void onMenuConfirmClicked(cocos2d::CCObject *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void refreshData(void);
	void addDatasInCondition(int, int, int,	int);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void addDatasNoMonster(int, int, int);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void Init(void);
	void addDatasNoMonster(int,int,int);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void init(void);
	void addDatasInCondition(int,int,int,int);
}
#endif