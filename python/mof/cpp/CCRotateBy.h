#ifndef MOF_CCROTATEBY_H
#define MOF_CCROTATEBY_H

class CCRotateBy{
public:
	void create(float,float);
	void create(float,float,float);
	void update(float);
	void copyWithZone(cocos2d::CCZone *);
	void startWithTarget(cocos2d::CCNode *);
	void create(float, float, float);
	void reverse(void);
	void ~CCRotateBy();
}
#endif