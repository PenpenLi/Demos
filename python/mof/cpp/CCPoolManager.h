#ifndef MOF_CCPOOLMANAGER_H
#define MOF_CCPOOLMANAGER_H

class CCPoolManager{
public:
	void addObject(cocos2d::CCObject *);
	void ~CCPoolManager();
	void finalize(void);
	void pop(void);
	void CCPoolManager(void);
	void purgePoolManager(void);
	void sharedPoolManager(void);
	void removeObject(cocos2d::CCObject *);
	void push(void);
}
#endif