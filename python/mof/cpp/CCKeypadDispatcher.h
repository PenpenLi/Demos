#ifndef MOF_CCKEYPADDISPATCHER_H
#define MOF_CCKEYPADDISPATCHER_H

class CCKeypadDispatcher{
public:
	void CCKeypadDispatcher(void);
	void forceAddDelegate(cocos2d::CCKeypadDelegate *);
	void ~CCKeypadDispatcher();
	void addDelegate(cocos2d::CCKeypadDelegate *);
	void forceRemoveDelegate(cocos2d::CCKeypadDelegate *);
	void removeDelegate(cocos2d::CCKeypadDelegate	*);
}
#endif