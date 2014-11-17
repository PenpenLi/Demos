#ifndef MOF_MYSTICALSHOPPROPSCONTAINER_H
#define MOF_MYSTICALSHOPPROPSCONTAINER_H

class MysticalShopPropsContainer{
public:
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void addDatas(void);
	void ~MysticalShopPropsContainer();
	void tableCellTouched(cocos2d::extension::CCTableView *,	cocos2d::extension::CCTableViewCell *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void Init(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,	unsigned int);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void init(void);
	void MysticalShopPropsContainer(void);
}
#endif