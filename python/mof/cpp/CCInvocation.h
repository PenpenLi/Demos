#ifndef MOF_CCINVOCATION_H
#define MOF_CCINVOCATION_H

class CCInvocation{
public:
	void getControlEvent(void);
	void getAction(void)const;
	void getTarget(void);
	void create(cocos2d::CCObject *,uint),uint);
	void getAction(void);
	void getControlEvent(void)const;
	void invoke(cocos2d::CCObject *);
	void ~CCInvocation();
	void getTarget(void)const;
}
#endif