#ifndef MOF_TOTEMDESTABLEVIEW_H
#define MOF_TOTEMDESTABLEVIEW_H

class TotemDesTableView{
public:
	void setDesc(std::vector<std::string, std::allocator<std::string>> &);
	void create(cocos2d::CCSize);
	void setDesc(std::vector<std::string,std::allocator<std::string>> &);
	void TotemDesTableView(void);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView	*);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView	*);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void Init(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void refreshData(void);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void ~TotemDesTableView();
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void init(void);
}
#endif