#ifndef MOF_PETTABLEVIEW_H
#define MOF_PETTABLEVIEW_H

class PetTableView{
public:
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void absortPet(int, int);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void deletePet(int);
	void absortPet(int,int);
	void setCellSeleted(uint,bool);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void PetTableView(void);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void tableCellHighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell	*);
	void tableCellHighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void tableCellHighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell	*);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void setCellSeleted(unsigned	int, bool);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void Init(void);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void addPet(PetMonster *);
	void create(void);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *,	cocos2d::extension::CCTableViewCell *);
	void ~PetTableView();
	void init(void);
}
#endif