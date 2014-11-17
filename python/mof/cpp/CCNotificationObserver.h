#ifndef MOF_CCNOTIFICATIONOBSERVER_H
#define MOF_CCNOTIFICATIONOBSERVER_H

class CCNotificationObserver{
public:
	void getTarget(void);
	void ~CCNotificationObserver();
	void getSelector(void);
	void getObject(void);
	void CCNotificationObserver(cocos2d::CCObject *),char const*,cocos2d::CCObject *);
	void getName(void);
}
#endif