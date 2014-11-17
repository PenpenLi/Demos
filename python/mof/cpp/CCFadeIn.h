#ifndef MOF_CCFADEIN_H
#define MOF_CCFADEIN_H

class CCFadeIn{
public:
	void copyWithZone(cocos2d::CCZone *);
	void reverse(void);
	void create(float);
	void ~CCFadeIn();
	void update(float);
}
#endif