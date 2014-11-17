#ifndef MOF_CCSHOW_H
#define MOF_CCSHOW_H

class CCShow{
public:
	void reverse(void);
	void ~CCShow();
	void create(void);
	void copyWithZone(cocos2d::CCZone	*);
	void update(float);
}
#endif