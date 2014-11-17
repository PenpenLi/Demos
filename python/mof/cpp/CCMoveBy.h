#ifndef MOF_CCMOVEBY_H
#define MOF_CCMOVEBY_H

class CCMoveBy{
public:
	void create(float,cocos2d::CCPoint const&);
	void ~CCMoveBy();
	void update(float);
	void copyWithZone(cocos2d::CCZone *);
	void startWithTarget(cocos2d::CCNode *);
	void reverse(void);
}
#endif