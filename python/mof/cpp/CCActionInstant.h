#ifndef MOF_CCACTIONINSTANT_H
#define MOF_CCACTIONINSTANT_H

class CCActionInstant{
public:
	void ~CCActionInstant();
	void step(float);
	void update(float);
	void copyWithZone(cocos2d::CCZone *);
	void CCActionInstant(void);
	void reverse(void);
	void isDone(void);
}
#endif