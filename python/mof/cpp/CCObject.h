#ifndef MOF_CCOBJECT_H
#define MOF_CCOBJECT_H

class CCObject{
public:
	void isEqual(cocos2d::CCObject const*);
	void retain(void);
	void CCObject(void);
	void release(void);
	void ~CCObject();
	void copy(void);
	void retainCount(void);
	void update(float);
	void autorelease(void);
}
#endif