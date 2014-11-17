#ifndef MOF_CCEASESINEINOUT_H
#define MOF_CCEASESINEINOUT_H

class CCEaseSineInOut{
public:
	void copyWithZone(cocos2d::CCZone *);
	void reverse(void);
	void ~CCEaseSineInOut();
	void create(cocos2d::CCActionInterval *);
	void update(float);
}
#endif