#ifndef MOF_CCSET_H
#define MOF_CCSET_H

class CCSet{
public:
	void end(void);
	void CCSet(cocos2d::CCSet const&);
	void addObject(cocos2d::CCObject *);
	void CCSet(void);
	void begin(void);
	void mutableCopy(void);
	void count(void);
	void copy(void);
	void ~CCSet();
	void removeAllObjects(void);
	void removeObject(cocos2d::CCObject *);
	void containsObject(cocos2d::CCObject *);
}
#endif