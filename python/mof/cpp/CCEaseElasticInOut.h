#ifndef MOF_CCEASEELASTICINOUT_H
#define MOF_CCEASEELASTICINOUT_H

class CCEaseElasticInOut{
public:
	void copyWithZone(cocos2d::CCZone *);
	void reverse(void);
	void ~CCEaseElasticInOut();
	void update(float);
	void create(cocos2d::CCActionInterval	*,float);
}
#endif