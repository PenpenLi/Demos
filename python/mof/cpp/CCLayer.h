#ifndef MOF_CCLAYER_H
#define MOF_CCLAYER_H

class CCLayer{
public:
	void ~CCLayer();
	void CCLayer(void);
	void ccTouchMoved(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchesBegan(cocos2d::CCSet *, cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void isKeypadEnabled(void);
	void setAccelerometerInterval(double);
	void isAccelerometerEnabled(void);
	void registerScriptTouchHandler(int, bool, int, bool);
	void setAccelerometerEnabled(bool);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchesMoved(cocos2d::CCSet *,cocos2d::CCEvent *);
	void ccTouchesEnded(cocos2d::CCSet	*, cocos2d::CCEvent *);
	void setTouchEnabled(bool);
	void isTouchEnabled(void);
	void setTouchPriority(int);
	void ccTouchesEnded(cocos2d::CCSet *, cocos2d::CCEvent *);
	void ccTouchesEnded(cocos2d::CCSet *,cocos2d::CCEvent *);
	void ccTouchesCancelled(cocos2d::CCSet *, cocos2d::CCEvent	*);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void getTouchPriority(void);
	void registerScriptTouchHandler(int,bool,int,bool);
	void ccTouchBegan(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void didAccelerate(cocos2d::CCAcceleration	*);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void keyMenuClicked(void);
	void ccTouchesBegan(cocos2d::CCSet	*, cocos2d::CCEvent *);
	void unregisterScriptTouchHandler(void);
	void ccTouchesBegan(cocos2d::CCSet	*,cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void ccTouchesBegan(cocos2d::CCSet *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void registerWithTouchDispatcher(void);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchesMoved(cocos2d::CCSet	*, cocos2d::CCEvent *);
	void ccTouchesMoved(cocos2d::CCSet *, cocos2d::CCEvent *);
	void setTouchMode(cocos2d::ccTouchesMode);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onEnter(void);
	void ccTouchMoved(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void didAccelerate(cocos2d::CCAcceleration *);
	void keyBackClicked(void);
	void ccTouchesMoved(cocos2d::CCSet	*,cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void ccTouchesEnded(cocos2d::CCSet	*,cocos2d::CCEvent *);
	void ccTouchesCancelled(cocos2d::CCSet *, cocos2d::CCEvent *);
	void ccTouchesCancelled(cocos2d::CCSet *,cocos2d::CCEvent *);
	void getTouchMode(void);
	void create(void);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void setKeypadEnabled(bool);
	void init(void);
	void onExit(void);
	void onEnterTransitionDidFinish(void);
}
#endif