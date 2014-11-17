#ifndef MOF_CCEASEBACKINOUT_H
#define MOF_CCEASEBACKINOUT_H

class CCEaseBackInOut{
public:
	void copyWithZone(cocos2d::CCZone *);
	void reverse(void);
	void ~CCEaseBackInOut();
	void create(cocos2d::CCActionInterval *);
	void update(float);
}
#endif