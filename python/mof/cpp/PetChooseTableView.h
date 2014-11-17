#ifndef MOF_PETCHOOSETABLEVIEW_H
#define MOF_PETCHOOSETABLEVIEW_H

class PetChooseTableView{
public:
	void ~PetChooseTableView();
	void chooseIsMainPet(bool);
	void showConfirmEffect(bool);
	void setCloseImageIsEnable(bool);
	void onMenuChooseMainPetClicked(cocos2d::CCObject *);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void initControl(void);
	void deletAllDatas(void);
	void MainPetChoosed(void);
	void setConfirmImageIsEnable(bool);
	void deleteBeabsortedPetDatas(void);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void addDatas(void);
	void MainPetChoosed4UpStep(void);
	void setIsChooseMainPetView4UpStep(bool);
	void tableCellTouched(cocos2d::extension::CCTableView *,	cocos2d::extension::CCTableViewCell *);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void onMenuConfirmClicked(cocos2d::CCObject *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void PetChooseTableView(void);
	void tableCellHighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellHighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void tableCellHighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell	*);
	void cheersPetChoosed(void);
	void showSelectEffect(cocos2d::CCNode *, cocos2d::CCPoint);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell	*);
	void setIsChooseMainPetView(bool);
	void showSelectEffect(cocos2d::CCNode *,cocos2d::CCPoint);
	void refreshBeabsortedPetDatas4UpStep(void);
	void setCheersPetLabelShow(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,	unsigned int);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void createControl(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void deleteConfirmEffect(void);
	void tableCellUnhighlight(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void deleteChooseImage(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void BeabsortedChoosed(void);
	void BeabsortedChoosed4UpStep(void);
	void init(void);
}
#endif