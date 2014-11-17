#ifndef MOF_CCEASEELASTICIN_H
#define MOF_CCEASEELASTICIN_H

class CCEaseElasticIn{
public:
	void copyWithZone(cocos2d::CCZone *);
	void reverse(void);
	void ~CCEaseElasticIn();
	void create(cocos2d::CCActionInterval *,float);
	void update(float);
}
#endif