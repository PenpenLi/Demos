#ifndef MOF_CCEASEBOUNCEIN_H
#define MOF_CCEASEBOUNCEIN_H

class CCEaseBounceIn{
public:
	void reverse(void);
	void ~CCEaseBounceIn();
	void copyWithZone(cocos2d::CCZone	*);
	void create(cocos2d::CCActionInterval *);
	void update(float);
}
#endif