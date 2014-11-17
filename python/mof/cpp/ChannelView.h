#ifndef MOF_CHANNELVIEW_H
#define MOF_CHANNELVIEW_H

class ChannelView{
public:
	void ~ChannelView();
	void registerWithTouchDispatcher(void);
	void create(void);
	void onEnter(void);
}
#endif