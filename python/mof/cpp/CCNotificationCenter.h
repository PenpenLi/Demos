#ifndef MOF_CCNOTIFICATIONCENTER_H
#define MOF_CCNOTIFICATIONCENTER_H

class CCNotificationCenter{
public:
	void ~CCNotificationCenter();
	void removeObserver(cocos2d::CCObject *, char const*);
	void purgeNotificationCenter(void);
	void unregisterScriptObserver(void);
	void observerExisted(cocos2d::CCObject *, char const*);
	void observerExisted(cocos2d::CCObject *,char const*);
	void addObserver(cocos2d::CCObject	*), char const*, cocos2d::CCObject *);
	void addObserver(cocos2d::CCObject *),char const*,cocos2d::CCObject	*);
	void CCNotificationCenter(void);
	void sharedNotificationCenter(void);
	void removeObserver(cocos2d::CCObject *,char const*);
}
#endif