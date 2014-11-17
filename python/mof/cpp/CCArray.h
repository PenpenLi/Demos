#ifndef MOF_CCARRAY_H
#define MOF_CCARRAY_H

class CCArray{
public:
	void removeObject(cocos2d::CCObject *,bool);
	void createWithArray(cocos2d::CCArray*);
	void replaceObjectAtIndex(unsigned int, cocos2d::CCObject *, bool);
	void insertObject(cocos2d::CCObject *,uint);
	void count(void);
	void removeObjectAtIndex(uint,bool);
	void lastObject(void);
	void insertObject(cocos2d::CCObject *, unsigned int);
	void initWithCapacity(unsigned int);
	void objectAtIndex(uint);
	void createWithCapacity(uint);
	void createWithCapacity(unsigned	int);
	void addObject(cocos2d::CCObject	*);
	void create(cocos2d::CCObject *,	...);
	void indexOfObject(cocos2d::CCObject *);
	void CCArray(void);
	void copyWithZone(cocos2d::CCZone *);
	void ~CCArray();
	void containsObject(cocos2d::CCObject *);
	void create(cocos2d::CCObject *,...);
	void removeObjectAtIndex(unsigned int, bool);
	void removeObject(cocos2d::CCObject *, bool);
	void initWithCapacity(uint);
	void create(void);
	void replaceObjectAtIndex(uint,cocos2d::CCObject	*,bool);
	void removeAllObjects(void);
	void init(void);
	void objectAtIndex(unsigned int);
}
#endif