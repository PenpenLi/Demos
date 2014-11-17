#ifndef MOF_CCKEYPADHANDLER_H
#define MOF_CCKEYPADHANDLER_H

class CCKeypadHandler{
public:
	void ~CCKeypadHandler();
	void initWithDelegate(cocos2d::CCKeypadDelegate *);
	void handlerWithDelegate(cocos2d::CCKeypadDelegate *);
	void getDelegate(void);
}
#endif