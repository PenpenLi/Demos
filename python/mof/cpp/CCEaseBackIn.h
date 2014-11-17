#ifndef MOF_CCEASEBACKIN_H
#define MOF_CCEASEBACKIN_H

class CCEaseBackIn{
public:
	void copyWithZone(cocos2d::CCZone *);
	void reverse(void);
	void ~CCEaseBackIn();
	void create(cocos2d::CCActionInterval *);
	void update(float);
}
#endif