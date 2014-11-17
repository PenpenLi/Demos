#ifndef MOF_CCEASEOUT_H
#define MOF_CCEASEOUT_H

class CCEaseOut{
public:
	void copyWithZone(cocos2d::CCZone *);
	void reverse(void);
	void ~CCEaseOut();
	void create(cocos2d::CCActionInterval *,float);
	void update(float);
}
#endif