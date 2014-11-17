#ifndef MOF_CCBEASEINSTANT_H
#define MOF_CCBEASEINSTANT_H

class CCBEaseInstant{
public:
	void ~CCBEaseInstant();
	void create(cocos2d::CCActionInterval *);
	void update(float);
}
#endif