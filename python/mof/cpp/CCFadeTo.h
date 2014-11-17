#ifndef MOF_CCFADETO_H
#define MOF_CCFADETO_H

class CCFadeTo{
public:
	void copyWithZone(cocos2d::CCZone *);
	void create(float,uchar);
	void ~CCFadeTo();
	void startWithTarget(cocos2d::CCNode *);
	void update(float);
}
#endif