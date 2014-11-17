#ifndef MOF_CCBROTATETO_H
#define MOF_CCBROTATETO_H

class CCBRotateTo{
public:
	void ~CCBRotateTo();
	void create(float,float);
	void startWithTarget(cocos2d::CCNode *);
	void copyWithZone(cocos2d::CCZone	*);
	void update(float);
}
#endif