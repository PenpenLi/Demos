#ifndef MOF_CCTABLEVIEWDELEGATE_H
#define MOF_CCTABLEVIEWDELEGATE_H

class CCTableViewDelegate{
public:
	void tableCellUnhighlight(cocos2d::extension::CCTableView	*,cocos2d::extension::CCTableViewCell *);
	void tableCellHighlight(cocos2d::extension::CCTableView *,cocos2d::extension::CCTableViewCell *);
	void tableCellWillRecycle(cocos2d::extension::CCTableView	*, cocos2d::extension::CCTableViewCell *);
	void tableCellWillRecycle(cocos2d::extension::CCTableView	*,cocos2d::extension::CCTableViewCell *);
	void ~CCTableViewDelegate();
	void tableCellUnhighlight(cocos2d::extension::CCTableView	*, cocos2d::extension::CCTableViewCell *);
}
#endif