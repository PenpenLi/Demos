#ifndef MOF_SERVERCONTAINER_H
#define MOF_SERVERCONTAINER_H

class ServerContainer{
public:
	void onReceiveDragInsideClicked(cocos2d::CCObject	*);
	void onReceiveDragInsideClicked(cocos2d::CCObject *);
	void create(void);
	void onReceiveTouchUpOutsideClicked(cocos2d::CCObject *);
	void ServerContainer(void);
	void clickedAction(float);
	void onEnter(void);
	void createControl(void);
	void chooseGoback(void);
	void onReceiveTouchUpInsideClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
	void ~ServerContainer();
}
#endif