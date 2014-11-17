#ifndef MOF_MAILTABLEVIEW_H
#define MOF_MAILTABLEVIEW_H

class MailTableView{
public:
	void changeMailLogoStatus(cocos2d::extension::CCTableViewCell *, MailData *);
	void setSprSelected(cocos2d::extension::CCTableViewCell *, bool, std::string);
	void onMenuItemDeleteClicked(cocos2d::CCObject *);
	void tableCellTouched(cocos2d::extension::CCTableView	*,cocos2d::extension::CCTableViewCell *);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void addDatas(int, int);
	void changeMailLogoStatus(cocos2d::extension::CCTableViewCell *,MailData *);
	void tableCellTouched(cocos2d::extension::CCTableView	*, cocos2d::extension::CCTableViewCell *);
	void tableCellTouched(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView *);
	void selectTabViewCell(cocos2d::extension::CCTableView *, cocos2d::extension::CCTableViewCell *, int);
	void tableCellTouched(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell	*);
	void addDatas(int,int);
	void isMailNull(void);
	void cellSizeForTable(cocos2d::extension::CCTableView	*);
	void tableCellAtIndex(cocos2d::extension::CCTableView *,uint);
	void cellSizeForTable(cocos2d::extension::CCTableView *);
	void Init(void);
	void tableCellAtIndex(cocos2d::extension::CCTableView	*, unsigned int);
	void tableCellAtIndex(cocos2d::extension::CCTableView	*,uint);
	void tableCellAtIndex(cocos2d::extension::CCTableView *, unsigned int);
	void create(void);
	void selectTabViewCell(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *,int);
	void MailTableView(void);
	void ~MailTableView();
	void setSprSelected(cocos2d::extension::CCTableViewCell *,bool,std::string);
	void numberOfCellsInTableView(cocos2d::extension::CCTableView	*);
	void init(void);
}
#endif