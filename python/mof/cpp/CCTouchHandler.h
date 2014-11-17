#ifndef MOF_CCTOUCHHANDLER_H
#define MOF_CCTOUCHHANDLER_H

class CCTouchHandler{
public:
	void getPriority(void);
	void ~CCTouchHandler();
	void initWithDelegate(cocos2d::CCTouchDelegate *,int);
	void initWithDelegate(cocos2d::CCTouchDelegate *,	int);
	void getDelegate(void);
}
#endif