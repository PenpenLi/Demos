#ifndef MOF_CCEASEBOUNCEINOUT_H
#define MOF_CCEASEBOUNCEINOUT_H

class CCEaseBounceInOut{
public:
	void copyWithZone(cocos2d::CCZone *);
	void reverse(void);
	void ~CCEaseBounceInOut();
	void create(cocos2d::CCActionInterval *);
	void update(float);
}
#endif