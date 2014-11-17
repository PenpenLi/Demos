#ifndef MOF_CCROTATETO_H
#define MOF_CCROTATETO_H

class CCRotateTo{
public:
	void create(float,float);
	void ~CCRotateTo();
	void update(float);
	void copyWithZone(cocos2d::CCZone *);
	void initWithDuration(float,float,float);
	void startWithTarget(cocos2d::CCNode *);
	void initWithDuration(float, float, float);
}
#endif