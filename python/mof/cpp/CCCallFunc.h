#ifndef MOF_CCCALLFUNC_H
#define MOF_CCCALLFUNC_H

class CCCallFunc{
public:
	void ~CCCallFunc();
	void create(void));
	void execute(void);
	void copyWithZone(cocos2d::CCZone *);
	void initWithTarget(cocos2d::CCObject	*);
	void update(float);
}
#endif