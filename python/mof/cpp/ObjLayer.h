#ifndef MOF_OBJLAYER_H
#define MOF_OBJLAYER_H

class ObjLayer{
public:
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void draw(void);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void registerWithTouchDispatcher(void);
	void ccTouchBegan(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void create(void);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ~ObjLayer();
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void init(void);
}
#endif