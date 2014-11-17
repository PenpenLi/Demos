#ifndef MOF_CCDELAYTIME_H
#define MOF_CCDELAYTIME_H

class CCDelayTime{
public:
	void copyWithZone(cocos2d::CCZone *);
	void reverse(void);
	void create(float);
	void ~CCDelayTime();
	void update(float);
}
#endif