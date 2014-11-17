#ifndef MOF_CHANNELCONTAINER_H
#define MOF_CHANNELCONTAINER_H

class ChannelContainer{
public:
	void onReceiveTouchDownClicked(cocos2d::CCObject	*);
	void onReceiveDragInsideClicked(cocos2d::CCObject	*);
	void onReceiveDragInsideClicked(cocos2d::CCObject *);
	void create(void);
	void ~ChannelContainer();
	void init(void);
	void onReceiveTouchUpOutsideClicked(cocos2d::CCObject *);
	void onEnter(void);
	void createControl(void);
	void onReceiveTouchDownClicked(cocos2d::CCObject *);
	void onReceiveTouchUpInsideClicked(cocos2d::CCObject *);
	void ChannelContainer(void);
	void onExit(void);
}
#endif