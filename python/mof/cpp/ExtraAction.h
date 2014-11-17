#ifndef MOF_EXTRAACTION_H
#define MOF_EXTRAACTION_H

class ExtraAction{
public:
	void create(void);
	void step(float);
	void ~ExtraAction();
	void copyWithZone(cocos2d::CCZone *);
	void reverse(void);
	void update(float);
}
#endif