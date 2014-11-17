#ifndef MOF_CCSCALETO_H
#define MOF_CCSCALETO_H

class CCScaleTo{
public:
	void create(float,float);
	void create(float,float,float);
	void ~CCScaleTo();
	void update(float);
	void copyWithZone(cocos2d::CCZone *);
	void startWithTarget(cocos2d::CCNode *);
	void create(float, float, float);
}
#endif