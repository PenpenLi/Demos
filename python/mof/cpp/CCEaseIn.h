#ifndef MOF_CCEASEIN_H
#define MOF_CCEASEIN_H

class CCEaseIn{
public:
	void copyWithZone(cocos2d::CCZone *);
	void reverse(void);
	void ~CCEaseIn();
	void create(cocos2d::CCActionInterval *,float);
	void update(float);
}
#endif