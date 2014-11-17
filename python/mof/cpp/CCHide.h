#ifndef MOF_CCHIDE_H
#define MOF_CCHIDE_H

class CCHide{
public:
	void reverse(void);
	void ~CCHide();
	void create(void);
	void copyWithZone(cocos2d::CCZone	*);
	void update(float);
}
#endif