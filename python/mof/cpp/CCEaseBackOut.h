#ifndef MOF_CCEASEBACKOUT_H
#define MOF_CCEASEBACKOUT_H

class CCEaseBackOut{
public:
	void copyWithZone(cocos2d::CCZone *);
	void reverse(void);
	void ~CCEaseBackOut();
	void create(cocos2d::CCActionInterval *);
	void update(float);
}
#endif