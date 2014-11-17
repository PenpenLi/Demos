#ifndef MOF_CCEASEELASTICOUT_H
#define MOF_CCEASEELASTICOUT_H

class CCEaseElasticOut{
public:
	void copyWithZone(cocos2d::CCZone *);
	void reverse(void);
	void ~CCEaseElasticOut();
	void create(cocos2d::CCActionInterval *,float);
	void update(float);
}
#endif