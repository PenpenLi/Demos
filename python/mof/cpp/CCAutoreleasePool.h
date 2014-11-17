#ifndef MOF_CCAUTORELEASEPOOL_H
#define MOF_CCAUTORELEASEPOOL_H

class CCAutoreleasePool{
public:
	void ~CCAutoreleasePool();
	void removeObject(cocos2d::CCObject *);
	void CCAutoreleasePool(void);
	void clear(void);
}
#endif