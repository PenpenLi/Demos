#ifndef MOF_CCEASEBOUNCEOUT_H
#define MOF_CCEASEBOUNCEOUT_H

class CCEaseBounceOut{
public:
	void copyWithZone(cocos2d::CCZone *);
	void reverse(void);
	void ~CCEaseBounceOut();
	void create(cocos2d::CCActionInterval *);
	void update(float);
}
#endif