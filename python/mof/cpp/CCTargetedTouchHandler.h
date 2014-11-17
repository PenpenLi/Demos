#ifndef MOF_CCTARGETEDTOUCHHANDLER_H
#define MOF_CCTARGETEDTOUCHHANDLER_H

class CCTargetedTouchHandler{
public:
	void initWithDelegate(cocos2d::CCTouchDelegate *,	int, bool);
	void ~CCTargetedTouchHandler();
	void getClaimedTouches(void);
	void isSwallowsTouches(void);
	void handlerWithDelegate(cocos2d::CCTouchDelegate	*,int,bool);
	void handlerWithDelegate(cocos2d::CCTouchDelegate	*, int,	bool);
	void initWithDelegate(cocos2d::CCTouchDelegate *,int,bool);
}
#endif