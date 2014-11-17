#ifndef MOF_CCTOUCHDISPATCHER_H
#define MOF_CCTOUCHDISPATCHER_H

class CCTouchDispatcher{
public:
	void touchesEnded(cocos2d::CCSet *, cocos2d::CCEvent *);
	void touchesBegan(cocos2d::CCSet *,cocos2d::CCEvent *);
	void addStandardDelegate(cocos2d::CCTouchDelegate *, int);
	void ~CCTouchDispatcher();
	void touchesEnded(cocos2d::CCSet *,cocos2d::CCEvent *);
	void forceAddHandler(cocos2d::CCTouchHandler *, cocos2d::CCArray *);
	void addTargetedDelegate(cocos2d::CCTouchDelegate *,int,bool);
	void addStandardDelegate(cocos2d::CCTouchDelegate *,int);
	void findHandler(cocos2d::CCArray *,cocos2d::CCTouchDelegate *);
	void forceRemoveDelegate(cocos2d::CCTouchDelegate *);
	void forceAddHandler(cocos2d::CCTouchHandler *,cocos2d::CCArray *);
	void touchesCancelled(cocos2d::CCSet *,cocos2d::CCEvent *);
	void touchesCancelled(cocos2d::CCSet *, cocos2d::CCEvent	*);
	void touches(cocos2d::CCSet *,cocos2d::CCEvent	*,uint);
	void touchesEnded(cocos2d::CCSet	*,cocos2d::CCEvent *);
	void touchesBegan(cocos2d::CCSet	*,cocos2d::CCEvent *);
	void removeAllDelegates(void);
	void addTargetedDelegate(cocos2d::CCTouchDelegate *, int, bool);
	void touchesCancelled(cocos2d::CCSet *, cocos2d::CCEvent *);
	void touchesBegan(cocos2d::CCSet	*, cocos2d::CCEvent *);
	void touchesBegan(cocos2d::CCSet *, cocos2d::CCEvent *);
	void touchesMoved(cocos2d::CCSet	*,cocos2d::CCEvent *);
	void touchesMoved(cocos2d::CCSet *,cocos2d::CCEvent *);
	void touchesEnded(cocos2d::CCSet	*, cocos2d::CCEvent *);
	void removeDelegate(cocos2d::CCTouchDelegate *);
	void touchesMoved(cocos2d::CCSet *, cocos2d::CCEvent *);
	void touches(cocos2d::CCSet *,	cocos2d::CCEvent *, unsigned int);
	void findHandler(cocos2d::CCArray *, cocos2d::CCTouchDelegate *);
	void touchesMoved(cocos2d::CCSet	*, cocos2d::CCEvent *);
	void init(void);
	void setDispatchEvents(bool);
}
#endif