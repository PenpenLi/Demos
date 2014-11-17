#ifndef MOF_CCPROGRESSTO_H
#define MOF_CCPROGRESSTO_H

class CCProgressTo{
public:
	void copyWithZone(cocos2d::CCZone *);
	void ~CCProgressTo();
	void create(float,float);
	void startWithTarget(cocos2d::CCNode *);
	void update(float);
}
#endif