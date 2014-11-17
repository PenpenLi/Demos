#ifndef MOF_CCSCALEBY_H
#define MOF_CCSCALEBY_H

class CCScaleBy{
public:
	void create(float,float);
	void create(float,float,float);
	void copyWithZone(cocos2d::CCZone *);
	void ~CCScaleBy();
	void startWithTarget(cocos2d::CCNode *);
	void create(float, float, float);
	void reverse(void);
}
#endif