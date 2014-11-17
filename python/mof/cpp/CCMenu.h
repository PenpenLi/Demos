#ifndef MOF_CCMENU_H
#define MOF_CCMENU_H

class CCMenu{
public:
	void ~CCMenu();
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void addChild(cocos2d::CCNode *,int,int);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setOpacity(unsigned char);
	void addChild(cocos2d::CCNode *,int);
	void setOpacityModifyRGB(bool);
	void initWithArray(cocos2d::CCArray *);
	void setColor(cocos2d::_ccColor3B	const&);
	void setEnabled(bool);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void createWithItems(cocos2d::CCMenuItem *,void *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void addChild(cocos2d::CCNode *);
	void ccTouchCancelled(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void removeChild(cocos2d::CCNode *,bool);
	void createWithItem(cocos2d::CCMenuItem *);
	void createWithItems(cocos2d::CCMenuItem *, void *);
	void removeChild(cocos2d::CCNode *, bool);
	void registerWithTouchDispatcher(void);
	void isEnabled(void);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setColor(cocos2d::_ccColor3B const&);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void getColor(void);
	void addChild(cocos2d::CCNode *, int);
	void getOpacity(void);
	void create(void);
	void setOpacity(uchar);
	void create(cocos2d::CCMenuItem *,...);
	void addChild(cocos2d::CCNode *, int, int);
	void create(cocos2d::CCMenuItem *, ...);
	void createWithArray(cocos2d::CCArray *);
	void itemForTouch(cocos2d::CCTouch *);
	void init(void);
	void onExit(void);
	void isOpacityModifyRGB(void);
}
#endif