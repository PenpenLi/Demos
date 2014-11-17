#ifndef MOF_LOADINGLAYER_H
#define MOF_LOADINGLAYER_H

class LoadingLayer{
public:
	void recieveThreadMessage(ThreadMessage *);
	void create(LoadingType);
	void autoUpdateTimeOut(float);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void progressUp(int);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void asyncLoading(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onEnter(void);
	void LoadingLayer(void);
	void endAutoUpdate(void);
	void ~LoadingLayer();
	void startAutoUpdate(void);
	void init(void);
	void onExit(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
}
#endif