#ifndef MOF_CCFADEOUT_H
#define MOF_CCFADEOUT_H

class CCFadeOut{
public:
	void copyWithZone(cocos2d::CCZone *);
	void reverse(void);
	void create(float);
	void ~CCFadeOut();
	void update(float);
}
#endif