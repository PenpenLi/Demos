#ifndef MOF_CCTABLEVIEW_H
#define MOF_CCTABLEVIEW_H

class CCTableView{
public:
	void _setIndexForCell(uint,cocos2d::extension::CCTableViewCell *);
	void updateCellAtIndex(unsigned int);
	void _updateContentSize(void);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void _addCellIfNecessary(cocos2d::extension::CCTableViewCell *);
	void removeCellAtIndex(unsigned int);
	void __offsetFromIndex(uint);
	void _offsetFromIndex(unsigned int);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void __offsetFromIndex(unsigned int);
	void ccTouchCancelled(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void __indexFromOffset(cocos2d::CCPoint);
	void scrollViewDidZoom(cocos2d::extension::CCScrollView *);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void reloadData(void);
	void scrollViewDidScroll(cocos2d::extension::CCScrollView *);
	void _updateCellPositions(void);
	void initWithViewSize(cocos2d::CCSize, cocos2d::CCNode *);
	void removeCellAtIndex(uint);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void create(cocos2d::extension::CCTableViewDataSource *,cocos2d::CCSize);
	void create(cocos2d::extension::CCTableViewDataSource *, cocos2d::CCSize,	cocos2d::CCNode	*);
	void initWithViewSize(cocos2d::CCSize,cocos2d::CCNode *);
	void dequeueCell(void);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void _moveCellOutOfSight(cocos2d::extension::CCTableViewCell *);
	void ~CCTableView();
	void scrollViewDidScroll(cocos2d::extension::CCScrollView	*);
	void setVerticalFillOrder(cocos2d::extension::CCTableViewVerticalFillOrder);
	void cellAtIndex(uint);
	void _setIndexForCell(unsigned int, cocos2d::extension::CCTableViewCell *);
	void _indexFromOffset(cocos2d::CCPoint);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void cellAtIndex(unsigned	int);
	void updateCellAtIndex(uint);
	void _offsetFromIndex(uint);
	void create(cocos2d::extension::CCTableViewDataSource *,cocos2d::CCSize,cocos2d::CCNode *);
}
#endif