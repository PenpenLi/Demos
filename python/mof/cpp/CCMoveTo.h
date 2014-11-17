#ifndef MOF_CCMOVETO_H
#define MOF_CCMOVETO_H

class CCMoveTo{
public:
	void copyWithZone(cocos2d::CCZone *);
	void startWithTarget(cocos2d::CCNode *);
	void ~CCMoveTo();
	void create(float,cocos2d::CCPoint const&);
}
#endif