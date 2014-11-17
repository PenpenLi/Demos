#ifndef MOF_CCEASEINOUT_H
#define MOF_CCEASEINOUT_H

class CCEaseInOut{
public:
	void copyWithZone(cocos2d::CCZone *);
	void reverse(void);
	void ~CCEaseInOut();
	void create(cocos2d::CCActionInterval *,float);
	void update(float);
}
#endif