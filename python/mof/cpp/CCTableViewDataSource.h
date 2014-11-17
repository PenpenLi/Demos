#ifndef MOF_CCTABLEVIEWDATASOURCE_H
#define MOF_CCTABLEVIEWDATASOURCE_H

class CCTableViewDataSource{
public:
	void tableCellSizeForIndex(cocos2d::extension::CCTableView *,uint);
	void ~CCTableViewDataSource();
	void cellSizeForTable(cocos2d::extension::CCTableView *);
}
#endif