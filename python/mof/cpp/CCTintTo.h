#ifndef MOF_CCTINTTO_H
#define MOF_CCTINTTO_H

class CCTintTo{
public:
	void copyWithZone(cocos2d::CCZone *);
	void create(float,uchar,uchar,uchar);
	void ~CCTintTo();
	void startWithTarget(cocos2d::CCNode *);
	void update(float);
}
#endif