#ifndef MOF_CCSTANDARDTOUCHHANDLER_H
#define MOF_CCSTANDARDTOUCHHANDLER_H

class CCStandardTouchHandler{
public:
	void ~CCStandardTouchHandler();
	void initWithDelegate(cocos2d::CCTouchDelegate *,int);
	void handlerWithDelegate(cocos2d::CCTouchDelegate	*, int);
	void handlerWithDelegate(cocos2d::CCTouchDelegate	*,int);
}
#endif