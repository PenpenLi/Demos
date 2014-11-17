#ifndef MOF_CCPROGRESSFROMTO_H
#define MOF_CCPROGRESSFROMTO_H

class CCProgressFromTo{
public:
	void ~CCProgressFromTo();
	void create(float,float,float);
	void update(float);
	void copyWithZone(cocos2d::CCZone *);
	void startWithTarget(cocos2d::CCNode *);
	void reverse(void);
}
#endif